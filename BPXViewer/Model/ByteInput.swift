//
//  ByteInput.swift
//  BPXViewer
//
//  Created by Yuri Edwrad on 7/6/22.
//

import Foundation

class ByteInput : ObservableObject {
    var byte: uint8 {
        UInt8(Int(value)!)
    }

    @Published var value = "" {
        didSet {
            let filtered = value.filter { v in v.isNumber };
            let numeric = Int(filtered)!;
            let newNumeric: Int;
            if numeric > 255 {
                newNumeric = 255;
            } else if numeric < 0 {
                newNumeric = 0;
            } else {
                newNumeric = numeric;
            }
            if numeric != newNumeric {
                let str = newNumeric.formatted();
                value = str;
            } else if value != filtered {
                value = filtered;
            }
        }
    }
}
