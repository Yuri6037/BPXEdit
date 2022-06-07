//
//  MainView.swift
//  BPXViewer
//
//  Created by Yuri Edwrad on 6/7/22.
//

import SwiftUI

struct MainView: View {
    @Binding var document: BPXDocument
    @Binding var bundle: Bundle?;
    @EnvironmentObject var errorHost: ErrorHost;
    @EnvironmentObject var sectionState: SectionState;

    var body: some View {
        HStack {
            MainHeaderView(bundle: $bundle, header: document.container?.getMainHeader())
            VStack {
                Text("BPX Type Ext").bold()
                HStack {
                    ToolButton(icon: "hexagon", text: "Hex View") {
                        let data = document.loadRaw(errorHost: errorHost, section: -1);
                        sectionState.showHex(data: data);
                    }
                    if bundle != nil && document.canDecode(section: -1, bundle: bundle!) {
                        ToolButton(icon: "doc", text: "Data View") {
                            let value = document.loadData(errorHost: errorHost, section: -1, bundle: bundle!);
                            sectionState.showData(value: value);
                        }
                    }
                }
            }
            .blockView()
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(document: .constant(BPXDocument()), bundle: .constant(nil))
    }
}
