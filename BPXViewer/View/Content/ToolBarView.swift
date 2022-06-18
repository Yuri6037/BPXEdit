//
//  ToolBarView.swift
//  BPXViewer
//
//  Created by Yuri Edwrad on 6/12/22.
//

import SwiftUI

struct ToolBarView: View {
    @EnvironmentObject var object: BPXObject;
    @EnvironmentObject var sectionState: SectionState;
    @EnvironmentObject var errorHost: ErrorHost;
    let section: Int;

    func loadHex() {
        sectionState.showHex(data: object.loadRaw(errorHost: errorHost, section: section));
    }

    func loadData() {
        sectionState.showData(value: object.loadData(errorHost: errorHost, section: section));
    }

    func loadStrings() {
        sectionState.showStrings(value: object.loadStrings(errorHost: errorHost, section: section));
    }

    func loadStructuredData() {
        sectionState.showStructuredData(value: object.loadStructuredData(errorHost: errorHost, section: section));
    }

    var body: some View {
        HStack {
            ToolButton(
                icon: "trash",
                text: "Delete Section",
                disabled: !object.isValid(section: section),
                action: { object.removeSection(section: section) }
            )
            Divider()
            ToolButton(
                icon: "hexagon",
                text: "Hex View",
                disabled: !object.isValid(section: section),
                action: { loadHex() }
            )
            ToolButton(
                icon: "doc",
                text: "Data View",
                disabled: !object.isValid(section: section) || !object.canDecode(section: section),
                action: { loadData() }
            )
            ToolButton(
                icon: "doc.text",
                text: "Strings View",
                disabled: !object.isValid(section: section),
                action: { loadStrings() }
            )
            ToolButton(
                icon: "doc.zipper",
                text: "BPXSD View",
                disabled: !object.isValid(section: section),
                action: { loadStructuredData() }
            )
        }
        .fixedSize()
        .padding(4)
    }
}

struct ToolBarView_Previews: PreviewProvider {
    static var previews: some View {
        ToolBarView(section: -1).environmentObject(SectionState()).environmentObject(BPXObject())
    }
}
