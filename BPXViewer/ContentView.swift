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
    @State var curSectionView: Value?;

    func loadSectionHex() {
        curSectionData = document.loadSectionAsData(index: selected);
    }

    func loadSectionView() {
        let data = document.loadSectionAsData(index: selected);
        guard let data = data else { return }
        curSectionView = BundleManager.instance.getBundle()?.typeDescs[selected]?.decode(buffer: data);
    }

    var body: some View {
        GeometryReader { geo in
            VStack {
                HStack {
                    VStack {
                        MainHeaderView(header: document.container?.getMainHeader())
                        Button(action: { loadSectionHex() }) {
                            HStack {
                                Image(systemName: "hexagon")
                                Text("Hex view")
                            }
                        }
                        Button(action: { loadSectionView() }) {
                            HStack {
                                Image(systemName: "doc")
                                Text("Decoded view")
                            }
                        }.disabled(BundleManager.instance.getBundle()?.typeDescs[selected] != nil)
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
            .sheet(isPresented: .constant(curSectionView != nil)) {
                DecodedView(value: $curSectionView)
                    .frame(width: geo.size.width * 0.7, height: geo.size.height * 0.6).padding()
                Button("Close") {
                    curSectionView = nil;
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
