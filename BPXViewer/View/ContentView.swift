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
    @EnvironmentObject var errorHost: ErrorHost;
    @State var bundle: Bundle?;

    func loadSectionHex(_ index: Int) {
        sectionState.showHexView(data: document.loadSectionAsData(errorHost, index: index));
    }

    func decodeSection(_ index: Int) {
        sectionState.showDecodedView(value: document.decodeSection(errorHost, index: index, bundle: bundle!));
    }

    func loadSectionStrings(_ index: Int) {
        sectionState.showStringView(value: document.loadSectionAsStrings(errorHost, index: index));
    }

    func loadSectionSd(_ index: Int) {
        sectionState.showSdView(value: document.loadSectionAsSdValue(errorHost, index: index));
    }

    var body: some View {
        GeometryReader { geo in
            VStack {
                HStack {
                    VStack {
                        HStack {
                            MainHeaderView(header: document.container?.getMainHeader())
                            VStack {
                                Text("BPX Type Ext").bold()
                                HStack {
                                    ToolButton(icon: "hexagon", text: "Hex View") {
                                        loadSectionHex(-1)
                                    }
                                    if bundle != nil && document.isSectionDecodable(index: -1, bundle: bundle!) {
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
                                            if bundle != nil && document.isSectionDecodable(index: section.index, bundle: bundle!) {
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
                        .padding()
                    }
                    //Main view
                    MainSectionView(document: $document)
                        .environmentObject(sectionState)
                        .frame(width: geo.size.width * 0.55)
                        .padding()
                }
            }
        }.onAppear {
            bundle = document.findBundle();
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(document: .constant(BPXDocument()))
    }
}
