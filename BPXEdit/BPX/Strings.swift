//
//  StringSection.swift
//  BPXViewer
//
//  Created by Yuri Edwrad on 5/29/22.
//

import Foundation

enum StringLoadError: Error {
    case invalidUtf8
    case truncation
}

extension SectionData {
    func loadString() throws -> String {
        var bytes = Data();
        while true {
            let byte = readByte();
            if byte == nil {
                break;
            }
            bytes.append(byte!);
            if byte! == 0 {
                let val = String(data: bytes, encoding: String.Encoding.utf8);
                if val == nil {
                    throw StringLoadError.invalidUtf8;
                }
                return val!;
            }
        }
        throw StringLoadError.truncation;
    }

    func loadStrings() -> [String] {
        var lst: [String] = [];
        seek(pos: 0);
        var bytes = Data();
        while true {
            let byte = readByte();
            if byte == nil {
                break;
            }
            bytes.append(byte!);
            if byte! == 0 {
                if let val = String(data: bytes, encoding: String.Encoding.utf8) {
                    lst.append(val);
                }
                bytes = Data();
            }
        }
        if let val = String(data: bytes, encoding: String.Encoding.utf8) {
            lst.append(val);
        }
        return lst;
    }
}
