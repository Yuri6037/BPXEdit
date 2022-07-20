//
//  ContentView.swift
//  BPXViewer
//
//  Created by Yuri Edwrad on 5/23/22.
//

import SwiftUI

struct ContentViewV2: View {
    @StateObject var object: BPXObject;
    @StateObject var sectionState = SectionState();
    @EnvironmentObject var errorHost: ErrorHost;
    @EnvironmentObject var globalState: GlobalState;
    @StateObject var windowState = WindowState();

    private func toggleSidebar() {
        #if os(iOS)
        #else
        NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
        #endif
    }

    var body: some View {
        GeometryReader { geo in
            NavigationView {
                SectionListView()
                    .environmentObject(object)
                    .environmentObject(sectionState)
                    .frame(minWidth: 180)
                    .toolbar {
                        ToolButton(icon: "sidebar.leading", text:   "Toggle Sidebar", action: toggleSidebar)
                    }
                SectionView(section: -1)
                    .environmentObject(object)
                    .environmentObject(sectionState)
                if !sectionState.isClosed() {
                    SectionContentView()
                        .environmentObject(object)
                        .environmentObject(sectionState)
                }
            }
            .sheet(isPresented: $windowState.showReInterpretMenu) {
                ReInterpretMenuModal(
                    isPresented: $windowState.showReInterpretMenu,
                    action: { bundle in
                        object.bundle = bundle;
                        sectionState.reset();
                    },
                    selected: object.bundle
                ).frame(width: geo.size.width * 0.5, height: geo.size.height * 0.5)
            }
            .overlay(WindowReader { window in
                if let window = window {
                    globalState.addWindow(
                        window: window,
                        model: windowState
                    );
                }
            })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentViewV2(object: BPXObject())
    }
}
