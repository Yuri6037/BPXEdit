//
//  ToolBarView.swift
//  BPXViewer
//
//  Created by Yuri Edwrad on 6/12/22.
//

import SwiftUI

struct ToolBarView: View {
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
        HStack {
            ToolButton(icon: "hexagon", text: "Hex View", disabled: selected < 0) {
                loadHex(selected)
            }
            ToolButton(icon: "doc", text: "Data View", disabled: selected < 0 || bundle == nil || !document.canDecode(section: selected, bundle: bundle!)) {
                loadData(selected)
            }
            ToolButton(icon: "doc.text", text: "Strings View", disabled: selected < 0) {
                loadStrings(selected)
            }
            ToolButton(icon: "doc.zipper", text: "BPXSD View", disabled: selected < 0) {
                loadStructuredData(selected)
            }
        }
        .padding(4)
    }
}

struct ToolBarView_Previews: PreviewProvider {
    static var previews: some View {
        ToolBarView(document: .constant(BPXDocument()), bundle: .constant(nil), selected: .constant(-1))
    }
}
