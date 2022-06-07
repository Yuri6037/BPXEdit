//
//  MainSectionView.swift
//  BPXViewer
//
//  Created by Yuri Edwrad on 6/3/22.
//

import SwiftUI

struct SectionView: View {
    @Binding var document: BPXDocument;
    @EnvironmentObject var sectionState: SectionState;

    var body: some View {
        switch sectionState.viewType {
        case .closed:
            Text("Please open a section view.")
        case .hex:
            HexViewWrapper(data: $sectionState.hexView)
        case .data:
            DataView(value: $sectionState.dataView, container: $document.container)
        case .bpxsd:
            ScrollView {
                SdView(value: $sectionState.structuredDataView)
            }
        case .strings:
            StringView(value: $sectionState.stringView)
        }
    }
}

struct MainSectionView_Previews: PreviewProvider {
    static var previews: some View {
        SectionView(document: .constant(BPXDocument()))
    }
}
