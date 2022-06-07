//
//  NavigationView.swift
//  BPXViewer
//
//  Created by Yuri Edwrad on 6/7/22.
//

import SwiftUI

struct NavigationView: View {
    @Binding var document: BPXDocument;
    @Binding var bundle: Bundle?;
    @Binding var selected: Int;
    @EnvironmentObject var sectionState: SectionState;
    @EnvironmentObject var errorHost: ErrorHost;

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
}

struct NavigationView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView(document: .constant(BPXDocument()), bundle: .constant(nil), selected: .constant(0))
    }
}
