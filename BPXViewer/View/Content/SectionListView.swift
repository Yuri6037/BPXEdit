//
//  NavigationView.swift
//  BPXViewer
//
//  Created by Yuri Edwrad on 6/7/22.
//

import SwiftUI

struct SectionListView: View {
    @EnvironmentObject var object: BPXObject;
    @EnvironmentObject var errorHost: ErrorHost;

    var body: some View {
        List {
            ForEach(object.sections) { section in
                NavigationLink(destination: SectionView(section: section.index)) {
                    VStack(alignment: .leading) {
                        Text("Section #\(section.index)").bold()
                        if let name = object.bundle?.main.getSectionName(code: section.header.ty) {
                            Text(name)
                        }
                    }
                }
            }
        }
    }
}

struct NavigationView_Previews: PreviewProvider {
    static var previews: some View {
        SectionListView()
            .environmentObject(BPXObject())
    }
}
