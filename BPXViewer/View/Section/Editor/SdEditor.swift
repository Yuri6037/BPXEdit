//
//  SdEditor.swift
//  BPXViewer
//
//  Created by Yuri Edwrad on 7/9/22.
//

import SwiftUI

struct SdEditorActions {
    let okName: String;
    let okAction: (SdValue) -> Void;
    let cancelAction: () -> Void;
}

struct SdEditor: View {
    @State var value: SdValue;
    @State var name = "";
    @State var newValue = "";
    @State var dataType: SdDataType = .string;
    @State var showValueEditor = false;
    let indentation: CGFloat;
    let step: CGFloat;
    let removeAction: (SdValue) -> Void;
    let actions: SdEditorActions?;

    init(value: SdValue, actions: SdEditorActions? = nil, indentation: CGFloat = 0, step: CGFloat = 24, removeAction: @escaping (SdValue) -> Void = { _ in }) {
        _value = State(initialValue: value);
        self.indentation = indentation;
        self.step = step;
        self.removeAction = removeAction;
        self.actions = actions;
    }

    func removeChild(value: SdValue) {
        self.value.children?.removeAll(where: { v in v.id == value.id })
    }

    func getIconName() -> String {
        if value.isArray {
            return "list.bullet"
        } else if (!value.isArray && value.children != nil) {
            return "tray.2";
        } else {
            return "doc.richtext"
        }
    }

    var body: some View {
        if value.children != nil {
            ScrollView {
                VStack(alignment: .leading) {
                    HStack {
                        Image(systemName: getIconName())
                        Text(value.description())
                            .textSelection(.enabled)
                        Button(action: { removeAction(value) }) {
                            Image(systemName: "minus")
                        }
                        .help("Remove item")
                    }
                    .padding(.leading, indentation)
                    VStack(alignment: .leading) {
                        ForEach(value.children!) { value in
                            SdEditor(
                                value: value,
                                indentation: indentation + step,
                                step: step,
                                removeAction: removeChild
                            )
                        }
                        Button(action: { showValueEditor.toggle() }) {
                            Image(systemName: "square.and.pencil")
                        }
                        .help("Insert item")
                        .popover(isPresented: $showValueEditor) {
                            SdValueField(withName: !value.isArray, insertAction: { v in value.children?.append(v) })
                                .frame(minWidth: 300)
                                .padding()
                        }
                        .padding(.leading, indentation + step)
                    }
                }
                .padding()
                if let actions = actions {
                    HStack {
                        Button("Cancel", action: actions.cancelAction)
                            .keyboardShortcut(.cancelAction)
                        Spacer()
                        Button(actions.okName) {
                            actions.okAction(value);
                        }
                        .keyboardShortcut(.defaultAction)
                    }
                    .padding()
                }
            }
        } else {
            HStack {
                Image(systemName: getIconName())
                Text(value.description())
                    .textSelection(.enabled)
                Button(action: { removeAction(value) }) {
                    Image(systemName: "minus")
                }
                .help("Remove item")
            }
            .padding(.leading, indentation)
        }
    }
}

struct SdEditor_Previews: PreviewProvider {
    static var previews: some View {
        SdEditor(value: SdValue(children: []))
    }
}
