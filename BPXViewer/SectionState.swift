//
//  SectionState.swift
//  BPXViewer
//
//  Created by Yuri Edwrad on 5/28/22.
//

import Foundation

class SectionState: ObservableObject {
    @Published var showHexView: Bool = false;
    @Published var showDecodedView: Bool = false;
    @Published var hexViewData: [uint8] = [];
    @Published var decodedViewData: Value = .scalar(.u8(0)); //Just a default value so that we don't crash DecodedView anymore.

    func showHexView(data: [uint8]?) {
        if let data = data {
            self.showHexView = true;
            self.hexViewData = data;
        } else {
            self.showHexView = false;
        }
    }

    func showDecodedView(value: Value?) {
        if let value = value {
            self.showDecodedView = true;
            self.decodedViewData = value;
        } else {
            self.showDecodedView = false;
        }
    }
}
