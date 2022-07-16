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
    @State var window: NSWindow?;
    @State var showTextInsert = false;
    @State var showBpxsdInsert = false;
    @State var text = "";
    let section: Int;

    func openBinaryFile() {
        let dialog = NSOpenPanel();
        dialog.title = "Choose a binary file to insert.";
        dialog.showsResizeIndicator = true;
        dialog.showsHiddenFiles = false;
        dialog.canChooseDirectories = false;
        dialog.canCreateDirectories = false;
        dialog.allowsMultipleSelection = false;
        dialog.beginSheetModal(for: window!) { response in
            if response == NSApplication.ModalResponse.OK {
                do {
                    let data = try Data(contentsOf: dialog.url!);
                    edit.insertBytes(data: data);
                } catch {
                    errorHost.spawn(ErrorInfo(message: String(describing: error), context: "Editor"));
                }
            }
        }
    }

    var body: some View {
        HexViewer(data: $edit.data, selectionChanged: { selection in edit.selection = selection })
            .overlay {
                WindowReader { window in
                    self.window = window;
                }
                .frame(width: 0, height: 0)
            }
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
                            openBinaryFile();
                        }
                        ToolButton(icon: "text.badge.plus", text: "Insert text") {
                            showTextInsert = true;
                        }
                        ToolButton(icon: "rectangle.stack.badge.plus", text: "Insert BPXSD Object") {
                            showBpxsdInsert = true;
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
                TextField("Value", text: $byte.value).padding()
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
            .sheet(isPresented: $showTextInsert) {
                TextField("Text", text: $text).padding()
                HStack {
                    Button("Cancel") { showTextInsert = false }.keyboardShortcut(.cancelAction)
                    Spacer()
                    Button("Insert") {
                        showTextInsert = false;
                        edit.insertBytes(data: Data(text.utf8));
                    }
                    .keyboardShortcut(.defaultAction)
                }
                .padding()
            }
            .sheet(isPresented: $showBpxsdInsert) {
                ScrollView {
                    SdEditor(value: SdValue(children: []))
                }
                .frame(maxHeight: 256)
                .padding()
                HStack {
                    Button("Cancel") { showBpxsdInsert = false }.keyboardShortcut(.cancelAction)
                    Spacer()
                    Button("Insert") {
                        showBpxsdInsert = false;
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
