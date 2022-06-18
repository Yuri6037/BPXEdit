//
//  MainSectionView.swift
//  BPXViewer
//
//  Created by Yuri Edwrad on 6/3/22.
//

import SwiftUI

struct SectionView: View {
    @EnvironmentObject var object: BPXObject;
    @EnvironmentObject var sectionState: SectionState;
    let section: Int;

    private func getSection() -> Section {
        return object.sections[section]
    }

    var body: some View {
        if !object.isValid(section: section) {
            Text("No selection.")
                .toolbar { ToolBarView(section: section) }
        } else {
            ScrollView {
                VStack {
                    if let name = object.bundle?.main.getSectionName(code: getSection().header.ty) {
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
            .toolbar { ToolBarView(section: section) }
            .onAppear {
                sectionState.reset()
            }
        }
    }
}

struct SectionView_Previews: PreviewProvider {
    static var previews: some View {
        SectionView(section: -1)
            .environmentObject(SectionState())
            .environmentObject(BPXObject())
    }
}
