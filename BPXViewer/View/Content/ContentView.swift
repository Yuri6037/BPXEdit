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
        NavigationView {
            /*VStack {
                MainView(document: $document, bundle: $bundle)*/
            SectionListView()
                .environmentObject(object)
                .environmentObject(sectionState)
                .frame(minWidth: 180)
                .toolbar {
                    ToolButton(icon: "sidebar.leading", text: "Toggle Sidebar", action: toggleSidebar)
                }
            SectionView(section: -1)
                .environmentObject(object)
            SectionContentView()
                .environmentObject(object)
                .environmentObject(sectionState)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentViewV2(object: BPXObject())
    }
}
