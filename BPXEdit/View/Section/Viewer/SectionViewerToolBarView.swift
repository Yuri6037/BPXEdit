//
//  SectionViewerToolBar.swift
//  BPXViewer
//
//  Created by Yuri Edwrad on 6/19/22.
//

import SwiftUI

struct SectionViewerToolBarView: View {
    @EnvironmentObject var object: BPXObject;
    @EnvironmentObject var sectionState: SectionState;
    @EnvironmentObject var errorHost: ErrorHost;
    let section: Int;

    func loadHex() {
        sectionState.showHex(data: object.loadOnDemand(errorHost: errorHost, section: section));
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
                icon: "rectangle.stack",
                text: "BPXSD View",
                disabled: !object.isValid(section: section),
                action: { loadStructuredData() }
            )
        }
    }
}

struct SectionViewerToolBarView_Previews: PreviewProvider {
    static var previews: some View {
        SectionViewerToolBarView(section: -1)
            .environmentObject(SectionState())
            .environmentObject(BPXObject())
    }
}
