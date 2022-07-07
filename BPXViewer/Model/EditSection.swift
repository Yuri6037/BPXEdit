//
//  EditSection.swift
//  BPXViewer
//
//  Created by Yuri Edwrad on 7/6/22.
//

import Foundation

class EditSection: ObservableObject {
    @Published var data: [uint8] = [];
    @Published var append = false;
    var section: SectionData?;
    var selection: Selection = Selection();

    func initialize(section: SectionData?) {
        data = section?.loadInMemory() ?? [];
        self.section = section;
        selection = Selection();
    }

    func removeBytes() {
        section?.seek(pos: UInt64(selection.start + selection.length));
        section?.remove(count: selection.length);
        data.removeSubrange(selection.start..<selection.end);
    }

    func insertByte(byte: uint8) {
        if append {
            section?.seek(pos: UInt64(selection.start + 1));
            let _ = section?.writeAppend([byte]);
            data.insert(byte, at: selection.start + 1);
        } else {
            section?.seek(pos: UInt64(selection.start));
            let _ = section?.write([byte]);
            data.remove(at: selection.start);
            data.insert(byte, at: selection.start);
        }
    }
}
