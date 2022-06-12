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

    fileprivate func getColor() -> Color? {
        if disabled {
            return nil;
        }
        if isPressed {
            return Color(NSColor.tertiaryLabelColor);
        }
        if isHovered {
            return Color(NSColor.quaternaryLabelColor);
        }
        return nil;
    }

    var body: some View {
        VStack {
            Image(systemName: icon)
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 18, height: 18)
                .opacity(disabled ? 0.5 : 1.0)
        }
        .help(text)
        .frame(width: 40, height: 28)
        .background(getColor())
        .cornerRadius(6)
        .onHover {flag in
            isHovered = flag
        }
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged {_ in
                    isPressed = true
                }
                .onEnded { _ in
                    isPressed = false
                    if !disabled {
                        action()
                    }
                }
        )
    }
}

struct ToolButton_Previews: PreviewProvider {
    static var previews: some View {
        ToolButton(icon: "doc", text: "This is a test", disabled: true) {}
    }
}
