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
    @StateObject var edit = EditSection();
    @State var showByteInsert = false;
    @StateObject var byte = ByteInput();
    let section: Int;

    var body: some View {
        HexViewer(data: $edit.data, selectionChanged: { selection in edit.selection = selection })
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Toggle(isOn: $edit.append) {
                        Text("Append new data")
                    }
                }
                ToolbarItem(placement: .automatic) {
                    Spacer()
                }
                ToolbarItem(placement: .automatic) {
                    HStack {
                        ToolButton(icon: "plus", text: "Insert byte") {
                            showByteInsert = true;
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
                        edit.removeBytes()
                    }
                }
            }
            .sheet(isPresented: $showByteInsert) {
                TextField("Value: ", text: $byte.value).padding()
                HStack{
                    Button("Cancel") { showByteInsert = false }.keyboardShortcut(.cancelAction)
                    Spacer()
                    Button("Insert") {
                        showByteInsert = false;
                        edit.insertByte(byte: byte.byte);
                    }
                    .keyboardShortcut(.defaultAction)
                }
                .padding()
            }
            .onDisappear {
                edit.section = nil;
            }
            .onAppear {
                edit.initialize(section: object.loadSection(errorHost: errorHost, section: section));
            }
    }
}

struct SectionEditor_Previews: PreviewProvider {
    static var previews: some View {
        SectionEditor(section: -1)
    }
}
