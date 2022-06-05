//
//  WindowReader.swift
//  BPXViewer
//
//  Created by Yuri Edwrad on 6/4/22.
//

import SwiftUI

struct WindowReader: NSViewRepresentable {
    @Binding var window: NSWindow?;

    func makeNSView(context: Context) -> some NSView {
        let view = NSView()
        DispatchQueue.main.async {
            self.window = view.window;
        }
        return view;
    }

    func updateNSView(_ nsView: NSViewType, context: Context) {}
}
