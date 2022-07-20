//
//  SdValue.swift
//  BPXViewer
//
//  Created by Yuri Edwrad on 7/20/22.
//

import Foundation

class SdValue: ObservableObject, Identifiable {
    struct Name {
        let hash: UInt64;
        let name: String?;

        init(name: String) {
            let hash = name.withCString { str in bpx_hash(str) };
            self.name = name;
            self.hash = hash;
        }

        init(hash: UInt64, name: String? = nil) {
            self.name = name;
            self.hash = hash;
        }
    }

    let id: UUID = UUID();
    let name: Name?;
    let data: Value.Scalar?;
    @Published var children: [SdValue]?;
    let isArray: Bool;

    init(name: Name? = nil, data: Value.Scalar? = nil, children: [SdValue]? = nil, isArray: Bool = false) {
        self.name = name;
        self.data = data;
        self.children = children;
        self.isArray = isArray;
    }

    func description() -> String {
        var str = "";
        if let name = name {
            if let name1 = name.name {
                str += String(format: "%@ (%X)", name1, name.hash);
            } else {
                str += String(format: "%X", name.hash);
            }
        }
        if let data = data {
            if name != nil {
                str += String(format: ": %@    %@", data.getTypeName(), data.toString());
            } else {
                str += String(format: "%@    %@", data.getTypeName(), data.toString());
            }
        }
        if data == nil && name != nil && children == nil {
            str += ": Null";
        }
        return str;
    }
}
