//
//  MainSectionView.swift
//  BPXViewer
//
//  Created by Yuri Edwrad on 6/3/22.
//

import SwiftUI

struct SectionContentView: View {
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

struct SectionView: View {
    @Binding var document: BPXDocument;
    @Binding var bundle: Bundle?;
    @EnvironmentObject var sectionState: SectionState;
    let section: Int;

    private func getSection() -> Section {
        return document.container!.getSections()[section]
    }

    var body: some View {
        if section == -1 {
            Text("No selection.")
        } else {
            ScrollView {
                VStack {
                    if let name = bundle?.main.getSectionName(code: getSection().header.ty) {
                        Text("Section #\(section)").bold()
                        Text(name)
                    } else {
                        Text("Section #\(section)").bold()
                    }
                }
                .blockView()
                SectionHeaderView(section: getSection())
                    .blockView()
                    .frame(maxWidth: .infinity)
            }
            .frame(minWidth: 300)
            .toolbar { ToolBarView(document: $document, bundle: $bundle, section: section) }
            .onAppear {
                sectionState.reset()
            }
        }
    }
}

struct SectionView_Previews: PreviewProvider {
    static var previews: some View {
        SectionView(document: .constant(BPXDocument()), bundle: .constant(nil), section: -1).environmentObject(SectionState())
    }
}
