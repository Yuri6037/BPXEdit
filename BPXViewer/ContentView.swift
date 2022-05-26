//
//  ContentView.swift
//  BPXViewer
//
//  Created by Yuri Edwrad on 5/23/22.
//

import SwiftUI

struct ContentView: View {
    @Binding var document: BPXDocument
    @State var selected = -1;
    @State var curSectionData: [uint8]?;

    var body: some View {
        GeometryReader { geo in
            VStack {
                HStack {
                    VStack {
                        MainHeaderView(header: document.container?.getMainHeader())
                        Button(action: { curSectionData = document.loadSectionAsData(index: selected) }) {
                            HStack {
                                Image(systemName: "hexagon")
                                Text("Hex view")
                            }
                        }
                        Button(action: {}) {
                            HStack {
                                Image(systemName: "doc")
                                Text("Decoded view")
                            }
                        }.disabled(true)
                    }
                    List {
                        SelectableItem(key: -1, selected: $selected) {
                            Text("BPX Type Ext").bold()
                        }
                        if let container = document.container {
                            ForEach(container.getSections()) { section in
                                SelectableItem(key: section.index, selected: $selected) {
                                    SectionHeaderView(section: section)
                                }
                            }
                        }
                    }
                }
            }
            .sheet(isPresented: .constant(curSectionData != nil)) {
                HexViewWrapper(data: $curSectionData)
                    .frame(width: geo.size.width * 0.7, height: geo.size.height * 0.6).padding()
                Button("Close") {
                    curSectionData = nil;
                }.padding()
            }
            .alert("Error", isPresented: .constant(document.error != nil)) {
                Text(document.error ?? "")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(document: .constant(BPXDocument()))
    }
}
