//
//  SectionState.swift
//  BPXViewer
//
//  Created by Yuri Edwrad on 5/28/22.
//

import Foundation

enum ViewType {
    case closed
    case hex
    case data
    case bpxsd
    case strings
}

class SectionState: ObservableObject {
    @Published var viewType: ViewType = .closed;
    @Published var stringView: [String] = [];
    @Published var hexView: [uint8] = [];
    @Published var dataView: Value = .scalar(.u8(0)); //Just a default value so that we don't crash DecodedView anymore.
    @Published var structuredDataView: SdValue = SdValue();

    func showStructuredData(value: SdValue?) {
        if let value = value {
            self.structuredDataView = value;
            self.viewType = .bpxsd;
        } else {
            self.viewType = .closed;
        }
    }

    func showStrings(value: [String]?) {
        if let value = value {
            self.stringView = value;
            self.viewType = .strings;
        } else {
            self.viewType = .closed;
        }
    }

    func showHex(data: [uint8]?) {
        if let data = data {
            self.hexView = data;
            self.viewType = .hex;
        } else {
            self.viewType = .closed;
        }
    }

    func showData(value: Value?) {
        if let value = value {
            self.dataView = value;
            self.viewType = .data;
        } else {
            self.viewType = .closed;
        }
    }
}
