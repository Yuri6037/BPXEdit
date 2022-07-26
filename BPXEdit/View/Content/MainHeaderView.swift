//
//  MainHeaderView.swift
//  BPXViewer
//
//  Created by Yuri Edwrad on 5/26/22.
//

import SwiftUI

struct MainHeaderView: View {
    @Binding var bundle: Bundle?;
    var header: bpx_main_header_t?;

    fileprivate func getType() -> String {
        if header!.ty >= 0x20 && header!.ty <= 0x7E {
            return String(bytes: [header!.ty], encoding: .ascii)!;
        } else {
            return String(format: "%02X", header!.ty);
        }
    }

    var body: some View {
        VStack {
            if let header = header {
                Text("Main Header").bold()
                HStack {
                    Text("Version: ").bold()
                    Spacer()
                    Text("\(header.version)")
                        .textSelection(.enabled)
                }
                HStack {
                    Text("Type: ").bold()
                    Spacer()
                    Text(getType())
                        .textSelection(.enabled)
                }
                HStack {
                    Text("Checksum: ").bold()
                    Spacer()
                    Text(String(format: "%X", header.chksum))
                        .textSelection(.enabled)
                }
                HStack {
                    Text("Recorded file size: ").bold()
                    Spacer()
                    Text("\(header.file_size)")
                        .textSelection(.enabled)
                }
                HStack {
                    Text("Number of sections: ").bold()
                    Spacer()
                    Text("\(header.section_num)")
                        .textSelection(.enabled)
                }
            } else {
                Text("No container loaded.")
            }
        }
    }
}

struct MainHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        MainHeaderView(bundle: .constant(nil), header: bpx_main_header_t())
    }
}
