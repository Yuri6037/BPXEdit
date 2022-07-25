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
    @State var byte: UInt8 = 0;
    @State var window: NSWindow?;
    @State var showTextInsert = false;
    @State var showBpxsdInsert = false;
    @State var showConfirmation = false;
    @State var text = "";
    let section: Int;

    func openBpxsdEditor() {
        edit.section?.seek(pos: UInt64(edit.selection.start));
        do {
            edit.lastValue = try edit.section?.loadStructuredData();
        } catch {
            edit.lastValue = nil;
        }
        showBpxsdInsert = true;
    }

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
    
    @ViewBuilder func renderHexViewer() -> some View {
        if edit.usePages {
            HexViewer(
                reader: $edit.section,
                selectionChanged: { selection in edit.selection = selection }
            )
        } else {
            HexViewer(
                data: $edit.data,
                selectionChanged: { selection in edit.selection = selection }
            )
        }
    }

    var body: some View {
        renderHexViewer()
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
                        openBpxsdEditor();
                    }
                }
            }
            ToolbarItem(placement: .automatic) {
                Spacer()
            }
            ToolbarItem(placement: .automatic) {
                ToolButton(icon: "trash", text: "Remove selection") {
                    showConfirmation = true;
                }
            }
        }
        .sheet(isPresented: $showByteInsert) {
            NumberInput(value: $byte, context: ()).padding()
            HStack{
                Button("Cancel") { showByteInsert = false }.keyboardShortcut(.cancelAction)
                Spacer()
                Button("Insert") {
                    showByteInsert = false;
                    edit.insertByte(byte: byte);
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
            SdEditor(
                value: edit.lastValue ?? SdValue(children: []),
                actions: SdEditorActions(
                    okName: "Save",
                    okAction: { value in
                        edit.insertBpxsd(value: value);
                        showBpxsdInsert = false;
                    },
                    cancelAction: {
                        showBpxsdInsert = false;
                    }
                )
            )
            .frame(maxHeight: 256)
        }
        .confirmationDialog("Are you sure to delete the selection?", isPresented: $showConfirmation) {
            Button("Yes", role: .destructive, action: { edit.removeBytes() })
            Button("No", role: .cancel, action: { })
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
