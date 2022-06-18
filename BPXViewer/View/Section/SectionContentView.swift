//
//  SectionContentView.swift
//  BPXViewer
//
//  Created by Yuri Edwrad on 6/18/22.
//

import SwiftUI

struct SectionContentView: View {
    @EnvironmentObject var object: BPXObject;
    @EnvironmentObject var sectionState: SectionState;

    var body: some View {
        switch sectionState.viewType {
        case .closed:
            Text("Please open a section view.")
        case .hex:
            HexViewWrapper(data: $sectionState.hexView)
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

struct SectionContentView_Previews: PreviewProvider {
    static var previews: some View {
        SectionContentView()
            .environmentObject(SectionState())
            .environmentObject(BPXObject())
    }
}
