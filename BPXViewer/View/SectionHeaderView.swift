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
            if let name = BundleManager.instance.getBundle()?.main.getSectionName(code: section.header.ty) {
                Text("Section #\(section.index)").bold()
                Text(name).bold().padding(.bottom)
            } else {
                Text("Section #\(section.index)").bold().padding(.bottom)
            }
            HStack {
                Text("Type: ").bold()
                Spacer()
                Text("\(getType())")
            }
            HStack {
                Text("Handle: ").bold()
                Spacer()
                Text("\(section.handle)")
            }
            HStack {
                Text("Pointer: ").bold()
                Spacer()
                Text("\(getPointer())")
            }
            HStack {
                Text("Size: ").bold()
                Spacer()
                Text("\(section.header.size)")
            }
            HStack {
                Text("Size (after compression): ").bold()
                Spacer()
                Text("\(section.header.csize)")
            }
            HStack {
                Text("Checksum: ").bold()
                Spacer()
                Text(String(format: "%X", section.header.chksum))
            }
            HStack {
                Text("Flags: ").bold()
                Spacer()
                Text("\(getFlags())")
            }
        }
    }
}

struct SectionHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        SectionHeaderView(section: Section(handle: 0, index: 0, header: bpx_section_header_t(), container: nil))
    }
}
