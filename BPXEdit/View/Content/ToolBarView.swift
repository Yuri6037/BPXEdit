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
    @State var showConfirmation = false;
    let section: Int;

    var body: some View {
        HStack {
            ToolButton(
                icon: sectionState.isViewer() ? "pencil" : "magnifyingglass",
                text: sectionState.isViewer() ? "Switch to Editor" : "Switch to Viewer",
                disabled: !object.isValid(section: section),
                action: {
                    if sectionState.isViewer() {
                        sectionState.viewMode = .editor(section)
                    } else {
                        sectionState.viewMode = .viewer(section)
                    }
                }
            )
            Spacer()
            ToolButton(
                icon: "trash",
                text: "Delete Section",
                disabled: !object.isValid(section: section),
                action: { showConfirmation = true }
            )
        }
        .confirmationDialog("Are you sure to delete this section?", isPresented: $showConfirmation) {
            Button("Yes", role: .destructive, action: { object.remove(section: section) })
            Button("No", role: .cancel, action: { })
        }
    }
}

struct ToolBarView_Previews: PreviewProvider {
    static var previews: some View {
        ToolBarView(section: -1)
            .environmentObject(SectionState())
            .environmentObject(BPXObject())
    }
}
