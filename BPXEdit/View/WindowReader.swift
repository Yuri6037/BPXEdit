//
//  WindowReader.swift
//  BPXViewer
//
//  Created by Yuri Edwrad on 6/4/22.
//

import SwiftUI

struct WindowReader: NSViewRepresentable {
    let action: (NSWindow?) -> Void;

    func makeNSView(context: Context) -> some NSView {
        let view = NSView()
        DispatchQueue.main.async {
            self.action(view.window)
        }
        return view;
    }

    func updateNSView(_ nsView: NSViewType, context: Context) {}
}
