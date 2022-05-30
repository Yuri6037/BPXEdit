//
//  StringSection.swift
//  BPXViewer
//
//  Created by Yuri Edwrad on 5/29/22.
//

import Foundation

extension SectionData {
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
                    lst.append(val)
                }
            }
        }
        return lst;
    }
}
