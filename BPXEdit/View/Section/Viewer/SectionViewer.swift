//
//  SectionContentViewer.swift
//  BPXViewer
//
//  Created by Yuri Edwrad on 6/19/22.
//

import SwiftUI

struct SectionViewer: View {
    @EnvironmentObject var object: BPXObject;
    @EnvironmentObject var sectionState: SectionState;

    var body: some View {
        switch sectionState.viewType {
        case .closed:
            Text("Please open a section view.")
        case .hex:
            HexViewer(data: $sectionState.hexView)
        case .data:
            DataView(value: $sectionState.dataView, container: $object.document.container)
        case .bpxsd:
            ScrollView {
                SdView(value: $sectionState.structuredDataView)
            }
        case .strings:
            StringView(value: $sectionState.stringView)
        }
    }
}

struct SectionViewer_Previews: PreviewProvider {
    static var previews: some View {
        SectionViewer()
            .environmentObject(SectionState())
            .environmentObject(BPXObject())
    }
}
