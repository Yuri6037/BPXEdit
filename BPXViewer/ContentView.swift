//
//  ContentView.swift
//  BPXViewer
//
//  Created by Yuri Edwrad on 5/23/22.
//

import SwiftUI

struct ContentView: View {
    @Binding var document: BPXDocument
    @State var selected = -1;

    var body: some View {
        VStack {
            HStack {
                VStack {
                    MainHeaderView(header: document.container?.getMainHeader())
                    Text("Here goes the tool bar")
                }
                List {
                    SelectableItem(key: -1, selected: $selected) {
                        Text("BPX Type Ext")
                    }
                    if let container = document.container {
                        ForEach(container.getSections()) { section in
                            SelectableItem(key: section.index, selected: $selected) {
                                SectionHeaderView(section: section)
                            }
                        }
                    }
                }
            }
            HexViewWrapper()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(document: .constant(BPXDocument()))
    }
}
