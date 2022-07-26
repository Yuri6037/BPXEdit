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
    @Published var refresh = 0;
    var usePages = false;
    var selection: Selection = Selection();
    var lastValue: SdValue? = nil;

    func initialize(section: SectionData?) {
        //Go figure why is Swift corrupting the value if embedded inside the condition.
        let brokenswift = section?.size ?? 0;
        if brokenswift / PAGE_SIZE > 0 {
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
        } else {
            refresh += 1;
        }
    }

    func insertBytes(data: Data) {
        if append {
            section?.seek(pos: UInt64(selection.start + 1));
            let _ = section?.writeAppend(Array(data));
            if !usePages {
                self.data.insert(contentsOf: data, at: selection.start + 1);
            } else {
                refresh += 1;
            }
        } else {
            section?.seek(pos: UInt64(selection.start));
            let _ = section?.write(Array(data));
            if !usePages {
                self.data.removeSubrange(selection.start..<min(selection.start + data.count, self.data.count))
                self.data.insert(contentsOf: data, at: selection.start);
            } else {
                refresh += 1;
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
            } else {
                refresh += 1;
            }
        }
    }

    func insertByte(byte: uint8) {
        if append {
            section?.seek(pos: UInt64(selection.start + 1));
            let _ = section?.writeAppend([byte]);
            if !usePages {
                data.insert(byte, at: selection.start + 1);
            } else {
                refresh += 1;
            }
        } else {
            section?.seek(pos: UInt64(selection.start));
            let _ = section?.write([byte]);
            if !usePages {
                data.remove(at: selection.start);
                data.insert(byte, at: selection.start);
            } else {
                refresh += 1;
            }
        }
    }
}
