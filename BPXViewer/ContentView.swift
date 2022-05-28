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
    @State var curDecodedSection: Value?;

    func loadSectionHex() {
        curSectionData = document.loadSectionAsData(index: selected);
    }

    func decodeSection() {
        let data = document.loadSectionAsData(index: selected);
        guard let data = data else { return }
        if selected != -1 {
            let ty = document.container!.getSections()[selected].header.ty;
            curDecodedSection = BundleManager.instance.getBundle()?.typeDescs[Int(ty)]?.decode(buffer: data);
        } else {
            curDecodedSection = BundleManager.instance.getBundle()?.typeDescs[selected]?.decode(buffer: data);
        }
    }

    func isSectionDecodable() -> Bool {
        if selected != -1 {
            let ty = document.container!.getSections()[selected].header.ty;
            return BundleManager.instance.getBundle()?.typeDescs[Int(ty)] != nil;
        } else {
            return BundleManager.instance.getBundle()?.typeDescs[selected] != nil
        }
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
                        Button(action: { decodeSection() }) {
                            HStack {
                                Image(systemName: "doc")
                                Text("Decoded view")
                            }
                        }.disabled(!isSectionDecodable())
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
            .sheet(isPresented: .constant(curDecodedSection != nil)) {
                DecodedView(value: $curDecodedSection)
                    .frame(width: geo.size.width * 0.4, height: geo.size.height * 0.5).padding()
                Button("Close") {
                    curDecodedSection = nil;
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
