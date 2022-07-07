//
//  HexView.swift
//  BPXViewer
//
//  Created by Yuri Edwrad on 5/23/22.
//

import Foundation
import Cocoa
import SwiftUI

struct Selection: Equatable {
    let start: Int;
    let end: Int;
    let length: Int;
    let bytes: [uint8]?; //If selection is too large (> 16 bytes) this field is not computed for performance reasons.
    // This field may also be nil if no data buffer is connected to the hex view.

    init(start: Int, end: Int, bytes: [uint8]? = nil) {
        self.start = start;
        self.end = end + 1;
        self.length = (end + 1) - start;
        self.bytes = bytes;
    }

    init() {
        start = 0;
        end = 0;
        length = 0;
        bytes = nil;
    }
}

protocol HexViewDelegate: AnyObject {
    func hexViewDidChangeSelection(_ selection: Selection);
}

@IBDesignable class HexView: NSViewController, NSTextViewDelegate {
    @IBOutlet var address: NSTextView!
    @IBOutlet var hex: NSTextView!
    @IBOutlet var ascii: NSTextView!
    private var bytesPerLine: Int = 16;
    private var charWidth: CGFloat = 0.0;
    private var observer: NSKeyValueObservation?;
    private var data: [uint8]?;
    private var hax = false;
    private var prevBytesPerLine: Int = 16;
    weak var delegate: HexViewDelegate?;

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
            if prevBytesPerLine == bytesPerLine {
                return; //It's useless to re-render the entire view if the width didn't change!
            }
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
            prevBytesPerLine = bytesPerLine;
        }
    }

    override func viewWillDisappear() {
        data = nil;
        hex.delegate = nil;
        ascii.delegate = nil;
        observer?.invalidate();
    }

    private func notifyDelegate(start: Int, end: Int) {
        let selection: Selection;
        let length = end - start;
        if length < 0 || start >= data?.count ?? 0 || end >= data?.count ?? 0 {
            //We're out of bounds.
            selection = Selection();
        } else if length <= 16 {
            if let data = data?[start...end] {
                selection = Selection(start: start, end: end, bytes: Array(data));
            } else {
                selection = Selection(start: start, end: end);
            }
        } else {
            selection = Selection(start: start, end: end);
        }
        delegate?.hexViewDidChangeSelection(selection);
    }

    private func setAsciiSelection(startByte: Int, endByte: Int) {
        let startAscii = startByte + startByte / bytesPerLine;
        let endAscii = (endByte + endByte / bytesPerLine) + 1;
        var cursor = ascii.selectedRange();
        cursor.location = startAscii;
        cursor.length = endAscii - startAscii;
        hax = true;
        ascii.setSelectedRange(cursor);
    }

    private func setHexSelection(startByte: Int, endByte: Int) {
        let startHex = (startByte * 3) + ((startByte * 3) / (bytesPerLine * 3));
        let endHex = ((endByte * 3) + ((endByte * 3) / (bytesPerLine * 3))) + 2;
        var cursor = hex.selectedRange();
        cursor.location = startHex;
        cursor.length = endHex - startHex;
        hax = true;
        hex.setSelectedRange(cursor);
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
            setAsciiSelection(startByte: startByteIndex, endByte: endByteIndex)
            if startByteIndex == endByteIndex {
                setHexSelection(startByte: startByteIndex, endByte: endByteIndex);
            }
            notifyDelegate(start: startByteIndex, end: endByteIndex);
        } else if notification.object as? NSTextView? == ascii {
            let cursor = ascii.selectedRange();
            let selectionStart = cursor.location;
            let selectionEnd = cursor.location + cursor.length;
            let startByteIndex = selectionStart - selectionStart / (bytesPerLine + 1);
            var endByteIndex = (selectionEnd - selectionEnd / (bytesPerLine + 1)) - 1;
            if endByteIndex < startByteIndex {
                endByteIndex = startByteIndex;
            }
            setHexSelection(startByte: startByteIndex, endByte: endByteIndex);
            if startByteIndex == endByteIndex {
                setAsciiSelection(startByte: startByteIndex, endByte: endByteIndex);
            }
            notifyDelegate(start: startByteIndex, end: endByteIndex);
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
        prevBytesPerLine = 0; //That forces re-rendering.
        data = buffer;
        render();
    }
}
