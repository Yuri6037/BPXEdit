//
//  ToolButton.swift
//  BPXViewer
//
//  Created by Yuri Edwrad on 5/29/22.
//

import SwiftUI

struct ToolButton: View {
    let icon: String;
    let text: String;
    let action: () -> Void;
    let disabled: Bool;
    @State var isHovered = false;
    @State var isPressed = false;

    init(icon: String, text: String, disabled: Bool = false, action: @escaping () -> Void) {
        self.icon = icon;
        self.text = text;
        self.action = action;
        self.disabled = disabled;
    }

    var body: some View {
        Button(action: self.action) {
            Image(systemName: icon)
        }
        .help(text)
        .disabled(disabled)
    }
}

struct ToolButton_Previews: PreviewProvider {
    static var previews: some View {
        ToolButton(icon: "doc", text: "This is a test", disabled: true) {}
    }
}
