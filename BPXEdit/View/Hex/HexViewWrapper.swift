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

struct HexViewWrapper<T: Reader>: NSViewControllerRepresentable {
    @Binding var data: [uint8];
    @Binding var reader: T?;
    @Binding var selection: Selection;
    @Binding var page: Int;
    
    func makeCoordinator() -> Coordinator {
        Coordinator($selection)
    }

    func makeNSViewController(context: Context) -> HexView {
        let view = HexView();
        view.delegate = context.coordinator;
        return view;
    }

    func updateNSViewController(_ controller: HexView, context: Context) {
        if let reader = reader {
            controller.setData(reader: reader);
            controller.setPage(page);
        } else {
            controller.setData(buffer: data);
        }
    }
}
