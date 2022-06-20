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
        switch sectionState.viewMode {
        case .editor(_):
            Text("Not yet supported.").toolbar { EmptyView() }
        case .viewer(let section):
            SectionViewer()
                .toolbar { SectionViewerToolBarView(section: section) }
        default:
            Text("Internal error!")
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
