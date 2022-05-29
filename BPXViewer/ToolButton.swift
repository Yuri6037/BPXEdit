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
    @State var isHovered = false;
    @State var isPressed = false;

    var body: some View {
        VStack {
            Image(systemName: icon)
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 18, height: 18)
        }
        .help(text)
        .frame(width: 40, height: 28)
        .background(isPressed ? Color(NSColor.tertiaryLabelColor) : (isHovered ? Color(NSColor.quaternaryLabelColor) : nil))
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
                    action()
                }
        )
    }
}
