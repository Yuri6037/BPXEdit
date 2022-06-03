//
//  MainSectionView.swift
//  BPXViewer
//
//  Created by Yuri Edwrad on 6/3/22.
//

import SwiftUI

struct MainSectionView: View {
    @Binding var document: BPXDocument;
    @EnvironmentObject var sectionState: SectionState;

    var body: some View {
        switch sectionState.viewType {
        case .closed:
            Text("Please open a section view.")
        case .hex:
            HexViewWrapper(data: $sectionState.hexViewData)
        case .decoded:
            DecodedView(value: $sectionState.decodedViewData, container: $document.container)
        case .bpxsd:
            ScrollView {
                SdView(value: $sectionState.sdViewData)
            }
        case .strings:
            StringView(value: $sectionState.stringViewData)
        }
    }
}

struct MainSectionView_Previews: PreviewProvider {
    static var previews: some View {
        MainSectionView(document: .constant(BPXDocument()))
    }
}
