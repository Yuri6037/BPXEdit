//
//  HexView.swift
//  BPXViewer
//
//  Created by Yuri Edwrad on 5/23/22.
//

import Foundation
import Cocoa
import SwiftUI

@IBDesignable class HexView: NSViewController, NSTextViewDelegate {
    @IBOutlet var address: NSTextView!
    @IBOutlet var hex: NSTextView!
    @IBOutlet var ascii: NSTextView!
    private var bytesPerLine: Int = 16;
    private var charWidth: CGFloat = 0.0;
    private var observer: NSKeyValueObservation?;
    private var data: [uint8]?;

    override func viewDidLoad() {
        hex.delegate = self;
        let font = NSFont.monospacedSystemFont(ofSize: 16, weight: .regular);
        hex.font = font;
        ascii.font = font;
        address.font = font;
        let size = NSAttributedString(string: "FF ", attributes: [NSAttributedString.Key.font: font]).size();
        charWidth = size.width;
        observer = view.layer?.observe(\.bounds) { object, _ in
            self.bytesPerLine = self.getMaxBytesPerLine();
            self.render();
        };
        bytesPerLine = getMaxBytesPerLine();
        render();
    }

    private func render() {
        if let data = data {
            var ascii = "";
            var address = "";
            var hex = "";
            var flag = true;
            for i in 0...data.count {
                let byte = data[i];
                hex += String(format: "%02X", byte);
                if flag {
                    address += String(format: "0x%08X", i);
                    flag = false;
                }
                if byte >= 0x20 && byte <= 0x7E {
                    ascii += String(bytes: [byte], encoding: .ascii)!;
                } else {
                    ascii += ".";
                }
                if ((i + 1) % bytesPerLine) == 0 {
                    hex += "\n";
                    ascii += "\n";
                    address += "\n";
                    flag = true;
                }
            }
            self.address.string = address;
            self.ascii.string = ascii;
            self.hex.string = hex;
        }
    }

    override func viewWillDisappear() {
        data = nil;
        hex.delegate = nil;
        observer?.invalidate();
    }

    func textViewDidChangeSelection(_ notification: Notification) {
        let cursor = hex.selectedRange();
        let selectionStart = cursor.location;
        let selectionEnd = cursor.location + cursor.length;
        let startByteIndex = (selectionStart - (selectionStart / ((bytesPerLine * 3) + 1))) / 3;
        let endByteIndex = (selectionEnd - (selectionEnd / ((bytesPerLine * 3) + 1))) / 3;
        let startAscii = startByteIndex + startByteIndex / bytesPerLine;
        let endAscii = (endByteIndex + endByteIndex / bytesPerLine) + 1;
        var cursor1 = ascii.selectedRange();
        cursor1.location = startAscii;
        cursor1.length = endAscii - startAscii;
        ascii.setSelectedRange(cursor1);
    }

    private func getMaxBytesPerLine() -> Int {
        let width = hex.frame.width;
        let chars = Int(width / charWidth);
        let maxChars = chars;
        return maxChars;
    }

    private func setData(buffer: [uint8]) {
        data = buffer;
        render();
    }
}

struct HexViewWrapper: NSViewControllerRepresentable {
    func makeNSViewController(context: Context) -> HexView {
        return HexView();
    }

    func updateNSViewController(_ controller: HexView, context: Context) {
    }
}
