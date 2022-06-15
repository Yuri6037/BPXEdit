//
//  NavigationView.swift
//  BPXViewer
//
//  Created by Yuri Edwrad on 6/7/22.
//

import SwiftUI

struct SectionListView: View {
    @Binding var document: BPXDocument;
    @Binding var bundle: Bundle?;
    @Binding var selected: Int;
    @EnvironmentObject var errorHost: ErrorHost;

    var body: some View {
        List {
            if let container = document.container {
                ForEach(container.getSections()) { section in
                    SelectableItem(key: section.index, selected: $selected) {
                        SectionHeaderView(section: section)
                    }
                }
            }
        }
        .padding()
    }
}

struct NavigationView_Previews: PreviewProvider {
    static var previews: some View {
        SectionListView(document: .constant(BPXDocument()), bundle: .constant(nil), selected: .constant(0))
    }
}
