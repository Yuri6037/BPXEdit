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
    private var hax = false;

    override func viewDidLoad() {
        hex.delegate = self;
        ascii.delegate = self;
        let font = NSFont.monospacedSystemFont(ofSize: 16, weight: .regular);
        hex.font = font;
        ascii.font = font;
        address.font = font;
        let size = NSAttributedString(string: "FF ", attributes: [NSAttributedString.Key.font: font]).size();
        charWidth = size.width;
        observer = view.observe(\.frame) { object, _ in
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
            for i in 0..<data.count {
                let byte = data[i];
                hex += String(format: "%02X ", byte);
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
        ascii.delegate = nil;
        observer?.invalidate();
    }

    func textViewDidChangeSelection(_ notification: Notification) {
        if hax {
            hax = false;
            return;
        }
        if notification.object as? NSTextView? == hex {
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
            hax = true;
            ascii.setSelectedRange(cursor1);
        } else if notification.object as? NSTextView? == ascii {
            let cursor = ascii.selectedRange();
            let selectionStart = cursor.location;
            let selectionEnd = cursor.location + cursor.length;
            let startByteIndex = selectionStart - selectionStart / (bytesPerLine + 1);
            var endByteIndex = (selectionEnd - selectionEnd / (bytesPerLine + 1)) - 1;
            if endByteIndex < startByteIndex {
                endByteIndex = startByteIndex;
            }
            let startHex = (startByteIndex * 3) + ((startByteIndex * 3) / (bytesPerLine * 3));
            let endHex = ((endByteIndex * 3) + ((endByteIndex * 3) / (bytesPerLine * 3))) + 2;
            var cursor1 = hex.selectedRange();
            cursor1.location = startHex;
            cursor1.length = endHex - startHex;
            hax = true;
            hex.setSelectedRange(cursor1);
        }
    }

    private func getMaxBytesPerLine() -> Int {
        let width = hex.frame.width;
        let chars = Int(width / charWidth);
        let maxChars = chars;
        return maxChars;
    }

    public func setData(buffer: [uint8]) {
        if data == buffer {
            return;
        }
        data = buffer;
        render();
    }
}

struct HexViewWrapper: NSViewControllerRepresentable {
    @Binding var data: [uint8];

    func makeNSViewController(context: Context) -> HexView {
        return HexView();
    }

    func updateNSViewController(_ controller: HexView, context: Context) {
        controller.setData(buffer: data);
    }
}
