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
    case decoded
    case bpxsd
    case strings
}

class SectionState: ObservableObject {
    @Published var viewType: ViewType = .closed;
    @Published var stringViewData: [String] = [];
    @Published var hexViewData: [uint8] = [];
    @Published var decodedViewData: Value = .scalar(.u8(0)); //Just a default value so that we don't crash DecodedView anymore.
    @Published var sdViewData: SdValue = SdValue();

    func showSdView(value: SdValue?) {
        if let value = value {
            self.sdViewData = value;
            self.viewType = .bpxsd;
        } else {
            self.viewType = .closed;
        }
    }

    func showStringView(value: [String]?) {
        if let value = value {
            self.stringViewData = value;
            self.viewType = .strings;
        } else {
            self.viewType = .closed;
        }
    }

    func showHexView(data: [uint8]?) {
        if let data = data {
            self.hexViewData = data;
            self.viewType = .hex;
        } else {
            self.viewType = .closed;
        }
    }

    func showDecodedView(value: Value?) {
        if let value = value {
            self.decodedViewData = value;
            self.viewType = .decoded;
        } else {
            self.viewType = .closed;
        }
    }
}
