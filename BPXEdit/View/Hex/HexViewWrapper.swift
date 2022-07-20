//
//  HexViewWrapper.swift
//  BPXViewer
//
//  Created by Yuri Edwrad on 6/23/22.
//

import Foundation
import SwiftUI

class Coordinator: NSObject, HexViewDelegate {
    @Binding var selection: Selection;

    init(_ selection: Binding<Selection>) {
        _selection = selection;
    }

    func hexViewDidChangeSelection(_ selection: Selection) {
        DispatchQueue.main.async {
            self.selection = selection;
        }
    }
}

struct HexViewWrapper: NSViewControllerRepresentable {
    @Binding var data: [uint8];
    @Binding var selection: Selection;
    
    func makeCoordinator() -> Coordinator {
        Coordinator($selection)
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
