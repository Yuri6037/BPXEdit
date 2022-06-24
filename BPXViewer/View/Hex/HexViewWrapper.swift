//
//  HexViewWrapper.swift
//  BPXViewer
//
//  Created by Yuri Edwrad on 6/23/22.
//

import Foundation
import SwiftUI

class Coordinator: HexViewDelegate {
    let parent: HexViewWrapper;

    init(_ parent: HexViewWrapper) {
        self.parent = parent;
    }

    func hexViewDidChangeSelection(_ selection: Selection) {
        self.parent.selection = selection;
    }
}

struct HexViewWrapper: NSViewControllerRepresentable {
    @Binding var data: [uint8];
    @Binding var selection: Selection;
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeNSViewController(context: Context) -> HexView {
        let view = HexView();
        view.delegate = context.coordinator;
        return view;
    }

    func updateNSViewController(_ controller: HexView, context: Context) {
        controller.setData(buffer: data);
    }
}
