//
//  MainHeaderView.swift
//  BPXViewer
//
//  Created by Yuri Edwrad on 5/26/22.
//

import SwiftUI

struct MainHeaderView: View {
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
                Text("BPX Main Header").bold().padding(.bottom)
                HStack {
                    Text("Version: ").bold()
                    Spacer()
                    Text("\(header.version)")
                }
                HStack {
                    Text("Type: ").bold()
                    Spacer()
                    Text(getType())
                }
                HStack {
                    Text("Checksum: ").bold()
                    Spacer()
                    Text("\(header.chksum)")
                }
                HStack {
                    Text("Recorded file size: ").bold()
                    Spacer()
                    Text("\(header.file_size)")
                }
                HStack {
                    Text("Number of sections: ").bold()
                    Spacer()
                    Text("\(header.section_num)")
                }
            } else {
                Text("No container loaded.")
            }
        }
        .padding()
        .background(.white)
        .cornerRadius(12)
        .padding()
    }
}

struct MainHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        MainHeaderView(header: bpx_main_header_t())
    }
}
