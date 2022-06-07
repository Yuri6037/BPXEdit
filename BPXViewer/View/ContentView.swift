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

    func loadHex(_ index: Int) {
        sectionState.showHex(data: document.loadRaw(errorHost: errorHost, section: index));
    }

    func loadData(_ index: Int) {
        sectionState.showData(value: document.loadData(errorHost: errorHost, section: index, bundle: bundle!));
    }

    func loadStrings(_ index: Int) {
        sectionState.showStrings(value: document.loadStrings(errorHost: errorHost, section: index));
    }

    func loadStructuredData(_ index: Int) {
        sectionState.showStructuredData(value: document.loadStructuredData(errorHost: errorHost, section: index));
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
                                        loadHex(-1)
                                    }
                                    if bundle != nil && document.canDecode(section: -1, bundle: bundle!) {
                                        ToolButton(icon: "doc", text: "Data View") {
                                            loadData(-1)
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
                                                loadHex(section.index)
                                            }
                                            if bundle != nil && document.canDecode(section: section.index, bundle: bundle!) {
                                                ToolButton(icon: "doc", text: "Data View") {
                                                    loadData(section.index)
                                                }
                                            }
                                            ToolButton(icon: "doc.text", text: "Strings View") {
                                                loadStrings(section.index)
                                            }
                                            ToolButton(icon: "doc.zipper", text: "BPXSD View") {
                                                loadStructuredData(section.index)
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
