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
    @EnvironmentObject var sectionState: SectionState;
    @EnvironmentObject var errorHost: ErrorHost;
    let section: Int;

    func loadHex() {
        sectionState.showHex(data: document.loadRaw(errorHost: errorHost, section: section));
    }

    func loadData() {
        sectionState.showData(value: document.loadData(errorHost: errorHost, section: section, bundle: bundle!));
    }

    func loadStrings() {
        sectionState.showStrings(value: document.loadStrings(errorHost: errorHost, section: section));
    }

    func loadStructuredData() {
        sectionState.showStructuredData(value: document.loadStructuredData(errorHost: errorHost, section: section));
    }

    var body: some View {
        HStack {
            ToolButton(icon: "hexagon", text: "Hex View", disabled: section < 0) {
                loadHex()
            }
            ToolButton(icon: "doc", text: "Data View", disabled: section < 0 || bundle == nil || !document.canDecode(section: section, bundle: bundle!)) {
                loadData()
            }
            ToolButton(icon: "doc.text", text: "Strings View", disabled: section < 0) {
                loadStrings()
            }
            ToolButton(icon: "doc.zipper", text: "BPXSD View", disabled: section < 0) {
                loadStructuredData()
            }
        }
        .fixedSize()
        .padding(4)
    }
}

struct ToolBarView_Previews: PreviewProvider {
    static var previews: some View {
        ToolBarView(document: .constant(BPXDocument()), bundle: .constant(nil), section: -1).environmentObject(SectionState())
    }
}
