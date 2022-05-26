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

    var body: some View {
        VStack {
            Text("Section #\(section.index)").bold().padding(.bottom)
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
                Text("\(section.header.chksum)")
            }
        }
    }
}

struct SectionHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        SectionHeaderView(section: Section(handle: 0, index: 0, header: bpx_section_header_t(), container: nil))
    }
}
