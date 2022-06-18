//
//  MainView.swift
//  BPXViewer
//
//  Created by Yuri Edwrad on 6/7/22.
//

import SwiftUI

fileprivate struct HeadersView: View {
    @EnvironmentObject var object: BPXObject;
    @EnvironmentObject var errorHost: ErrorHost;
    @Binding var typeExt: Value?;
    @State var showHexView = false;
    @State var showDataView = false;
    @State var dataView: Value = .scalar(.u8(0));
    @State var hexView: [uint8] = [];

    var body: some View {
        HStack(alignment: .top) {
            MainHeaderView(bundle: $object.bundle, header: object.document.container?.getMainHeader())
            Divider()
            VStack {
                Text("Type Ext").bold()
                if typeExt != nil {
                    DataView(value: .constant(typeExt!), container: $object.document.container)
                }
                HStack {
                    ToolButton(icon: "hexagon", text: "Hex View") {
                        let data = object.loadRaw(errorHost: errorHost, section: -1);
                        if let data = data {
                            showHexView = true;
                            hexView = data;
                        }
                    }
                    if typeExt == nil {
                        ToolButton(
                            icon: "doc",
                            text: "Data View",
                            disabled: !object.canDecode(section: -1),
                            action: {
                                let value = object.loadData(errorHost: errorHost, section: -1);
                                if let value = value {
                                    showDataView = true;
                                    dataView = value;
                                }
                            }
                        )
                    }
                }
            }
        }
        .fixedSize(horizontal: false, vertical: true)
        .sheet(isPresented: $showHexView) {
            VStack {
                HexViewWrapper(data: $hexView).frame(minWidth: 500, minHeight: 80)
                Button("Close") { showHexView = false }
            }
            .padding()
        }
        .sheet(isPresented: $showDataView) {
            VStack {
                DataView(value: $dataView, container: $object.document.container)
                Button("Close") { showDataView = false }
            }
            .padding()
        }
    }
}

struct MainView: View {
    @EnvironmentObject var object: BPXObject;
    @EnvironmentObject var errorHost: ErrorHost;
    @State var typeExt: Value?;

    fileprivate let minWidth: CGFloat = 512;

    func updateState(width: CGFloat) {
        if width >= minWidth && typeExt == nil {
            let data = object.loadData(errorHost: errorHost, section: -1);
            if let data = data {
                typeExt = data;
            } else {
                typeExt = .scalar(.string("TypeExt parse error"));
            }
        } else if typeExt != nil && width < minWidth {
            typeExt = nil;
        }
    }

    var body: some View {
        if let name = object.bundle?.main.name {
            VStack {
                Text(name).bold().padding(.bottom)
                HeadersView(typeExt: $typeExt)
            }
            .blockView()
            .overlay {
                GeometryReader { geo in
                    EmptyView()
                        .onAppear { updateState(width: geo.size.width) }
                        .onChange(of: geo.size) { size in updateState(width: size.width) }
                }
            }
        } else {
            HeadersView(typeExt: .constant(nil)).blockView()
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView().environmentObject(BPXObject())
    }
}
