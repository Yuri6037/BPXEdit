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
    @StateObject var sectionState = SectionState();

    func loadSectionHex(_ index: Int) {
        sectionState.showHexView(data: document.loadSectionAsData(index: index));
    }

    func decodeSection(_ index: Int) {
        sectionState.showDecodedView(value: document.decodeSection(index: index));
    }

    func loadSectionStrings(_ index: Int) {
        sectionState.showStringView(value: document.loadSectionAsStrings(index: index));
    }

    func loadSectionSd(_ index: Int) {
        sectionState.showSdView(value: document.loadSectionAsSdValue(index: index));
    }

    var body: some View {
        GeometryReader { geo in
            VStack {
                HStack {
                    VStack {
                        MainHeaderView(header: document.container?.getMainHeader())
                        VStack {
                            Text("BPX Type Ext").bold()
                            HStack {
                                ToolButton(icon: "hexagon", text: "Hex View") {
                                    loadSectionHex(-1)
                                }
                                if document.isSectionDecodable(index: -1) {
                                    ToolButton(icon: "doc", text: "Data View") {
                                        decodeSection(-1)
                                    }
                                }
                            }
                        }
                        .blockView()
                    }
                    List {
                        if let container = document.container {
                            ForEach(container.getSections()) { section in
                                SelectableItem(key: section.index, selected: $selected) {
                                    SectionHeaderView(section: section)
                                    HStack {
                                        ToolButton(icon: "hexagon", text: "Hex View") {
                                            loadSectionHex(section.index)
                                        }
                                        if document.isSectionDecodable(index: section.index) {
                                            ToolButton(icon: "doc", text: "Data View") {
                                                decodeSection(section.index)
                                            }
                                        }
                                        ToolButton(icon: "doc.text", text: "Strings View") {
                                            loadSectionStrings(section.index)
                                        }
                                        ToolButton(icon: "doc.zipper", text: "BPXSD View") {
                                            loadSectionSd(section.index)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .sheet(isPresented: $sectionState.showHexView) {
                HexViewWrapper(data: $sectionState.hexViewData)
                    .frame(width: geo.size.width * 0.7, height: geo.size.height * 0.6).padding()
                Button("Close") { sectionState.showHexView(data: nil) }.padding()
            }
            .sheet(isPresented: $sectionState.showDecodedView) {
                DecodedView(value: $sectionState.decodedViewData, container: $document.container)
                    .frame(width: geo.size.width * 0.4).padding()
                Button("Close") { sectionState.showDecodedView(value: nil) }.padding()
            }
            .sheet(isPresented: $sectionState.showStringView) {
                StringView(value: $sectionState.stringViewData)
                    .frame(width: geo.size.width * 0.4)
                    .frame(minHeight: 200).padding()
                Button("Close") { sectionState.showStringView(value: nil) }.padding()
            }
            .sheet(isPresented: $sectionState.showSdView) {
                ScrollView {
                    SdView(value: $sectionState.sdViewData)
                }
                .frame(width: geo.size.width * 0.4)
                .frame(minHeight: 200).padding()
                Button("Close") { sectionState.showSdView(value: nil) }.padding()
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
