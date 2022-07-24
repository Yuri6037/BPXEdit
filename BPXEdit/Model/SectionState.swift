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

enum ViewMode {
    case editor(Int)
    case viewer(Int)
    case none
}

class SectionState: ObservableObject {
    @Published var viewType: ViewType = .closed;
    @Published var stringView: [String] = [];
    @Published var hexView: SectionData? = nil;
    @Published var dataView: Value = .scalar(.u8(0)); //Just a default value so that we don't crash DecodedView anymore.
    @Published var structuredDataView: SdValue = SdValue();
    @Published var viewMode: ViewMode = .none;

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

    func reset() {
        self.viewType = .closed;
        self.hexView = nil;
        self.stringView = [];
        self.dataView = .scalar(.u8(0));
        self.structuredDataView = SdValue();
        self.viewMode = .none;
    }
    
    func isClosed() -> Bool {
        switch viewMode {
        case .none:
            return true;
        default:
            return false;
        }
    }

    func isViewer() -> Bool {
        switch viewMode {
        case .viewer(_):
            return true;
        default:
            return false;
        }
    }

    func showHex(data: SectionData?) {
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
