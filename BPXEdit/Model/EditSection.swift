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
    @Published var section: SectionData?;
    var usePages = false;
    var selection: Selection = Selection();
    var lastValue: SdValue? = nil;

    func initialize(section: SectionData?) {
        if section?.size ?? 0 / PAGE_SIZE > 0 {
            usePages = true;
            data = [];
        } else {
            usePages = false;
            data = section?.loadInMemory() ?? [];
        }
        self.section = section;
        selection = Selection();
    }

    func removeBytes() {
        section?.seek(pos: UInt64(selection.start + selection.length));
        section?.remove(count: selection.length);
        if !usePages {
            data.removeSubrange(selection.start..<selection.end);
        }
    }

    func insertBytes(data: Data) {
        if append {
            section?.seek(pos: UInt64(selection.start + 1));
            let _ = section?.writeAppend(Array(data));
            if !usePages {
                self.data.insert(contentsOf: data, at: selection.start + 1);
            }
        } else {
            section?.seek(pos: UInt64(selection.start));
            let _ = section?.write(Array(data));
            if !usePages {
                self.data.removeSubrange(selection.start..<min(selection.start + data.count, self.data.count))
                self.data.insert(contentsOf: data, at: selection.start);
            }
        }
    }

    func insertBpxsd(value: SdValue) {
        if let section = section {
            let root = SdCValue(from: value);
            section.seek(pos: UInt64(selection.start));
            root.write(section: section);
            if !usePages {
                data = section.loadInMemory();
            }
        }
    }

    func insertByte(byte: uint8) {
        if append {
            section?.seek(pos: UInt64(selection.start + 1));
            let _ = section?.writeAppend([byte]);
            if !usePages {
                data.insert(byte, at: selection.start + 1);
            }
        } else {
            section?.seek(pos: UInt64(selection.start));
            let _ = section?.write([byte]);
            if !usePages {
                data.remove(at: selection.start);
                data.insert(byte, at: selection.start);
            }
        }
    }
}
