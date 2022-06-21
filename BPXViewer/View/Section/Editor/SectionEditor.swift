//
//  SectionEditor.swift
//  BPXViewer
//
//  Created by Yuri Edwrad on 6/20/22.
//

import SwiftUI

struct SectionEditor: View {
    @EnvironmentObject var object: BPXObject;
    @EnvironmentObject var errorHost: ErrorHost;
    @State var data: [uint8] = [];
    @State var append = true;
    let section: Int;

    var body: some View {
        HexViewWrapper(data: $data)
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Toggle(isOn: $append) {
                        Text("Append new data")
                    }
                }
                ToolbarItem(placement: .automatic) {
                    Spacer()
                }
                ToolbarItem(placement: .automatic) {
                    HStack {
                        ToolButton(icon: "plus", text: "Insert byte") {
                        
                        }
                        ToolButton(icon: "doc.badge.plus", text: "Insert raw binary") {
                        
                        }
                        ToolButton(icon: "text.badge.plus", text: "Insert text") {
                        
                        }
                        ToolButton(icon: "rectangle.stack.badge.plus", text: "Insert BPXSD Object") {
                        
                        }
                    }
                }
                ToolbarItem(placement: .automatic) {
                    Spacer()
                }
                ToolbarItem(placement: .automatic) {
                    ToolButton(icon: "trash", text: "Remove selection") {
                        
                    }
                }
            }
            .onAppear {
                data = object.loadRaw(errorHost: errorHost, section: section) ?? [];
            }
    }
}

struct SectionEditor_Previews: PreviewProvider {
    static var previews: some View {
        SectionEditor(section: -1)
    }
}
