//
//  MainView.swift
//  BPXViewer
//
//  Created by Yuri Edwrad on 6/7/22.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var object: BPXObject;
    @EnvironmentObject var errorHost: ErrorHost;
    @EnvironmentObject var sectionState: SectionState;
    @State var dataView: Value?;
    @State var hexView: [uint8]?;

    var body: some View {
        ScrollView {
            MainHeaderView(bundle: $object.bundle, header: object.document.container?.getMainHeader())
                .blockView()
            if let value = dataView {
                VStack {
                    Text("Data View").bold()
                    DataView(
                        value: .constant(value),
                        container: $object.document.container
                    )
                }
                .blockView()
            }
            if let hex = hexView {
                VStack {
                    Text("Hex View").bold()
                    HexViewer(data: .constant(hex))
                        .frame(height: 200)
                }
                .blockView()
            }
        }
        .frame(minWidth: 350)
        .toolbar { ToolBarView(section: -1) }
        .onAppear {
            let hex = object.loadRaw(errorHost: errorHost, section: -1);
            let data = object.loadData(errorHost: errorHost, section: -1);
            dataView = data;
            hexView = hex;
            sectionState.reset();
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(BPXObject())
            .environmentObject(SectionState())
    }
}
