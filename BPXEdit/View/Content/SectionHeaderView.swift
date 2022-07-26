//
//  SectionHeaderView.swift
//  BPXViewer
//
//  Created by Yuri Edwrad on 5/26/22.
//

import SwiftUI

struct SectionHeaderView: View {
    var section: Section;

    fileprivate func getType() -> String {
        return String(format: "%02X", section.header.ty);
    }

    fileprivate func getPointer() -> String {
        return String(format: "0x%08X", section.header.pointer);
    }

    fileprivate func getFlags() -> String {
        let flags = [
            "CompressZlib": UInt64(0x1),
            "CompressXZ": UInt64(0x2),
            "CheckCrc32": UInt64(0x4),
            "CheckWeak": UInt64(0x8)
        ];
        return parseBitflag(flags: flags, field: UInt64(section.header.flags));
    }

    var body: some View {
        VStack {
            HStack {
                Text("Type: ").bold()
                Spacer()
                Text("\(getType())")
                    .textSelection(.enabled)
            }
            HStack {
                Text("Handle: ").bold()
                Spacer()
                Text("\(section.handle)")
                    .textSelection(.enabled)
            }
            HStack {
                Text("Pointer: ").bold()
                Spacer()
                Text("\(getPointer())")
                    .textSelection(.enabled)
            }
            HStack {
                Text("Size: ").bold()
                Spacer()
                Text("\(section.header.size)")
                    .textSelection(.enabled)
            }
            HStack {
                Text("Size (after compression): ").bold()
                Spacer()
                Text("\(section.header.csize)")
                    .textSelection(.enabled)
            }
            HStack {
                Text("Checksum: ").bold()
                Spacer()
                Text(String(format: "%X", section.header.chksum))
                    .textSelection(.enabled)
            }
            HStack {
                Text("Flags: ").bold()
                Spacer()
                Text("\(getFlags())")
                    .textSelection(.enabled)
            }
        }
    }
}

struct SectionHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        SectionHeaderView(section: Section(handle: 0, index: 0, header: bpx_section_header_t(), container: nil))
    }
}
