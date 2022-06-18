//
//  BPXViewerApp.swift
//  BPXViewer
//
//  Created by Yuri Edwrad on 5/23/22.
//

import SwiftUI

@main
struct BPXViewerApp: App {
    @StateObject var globalState = GlobalState();

    init() {
        if BundleManager.instance.isErrored() {
            openBundleManagerWindow()
        }
    }

    var body: some Scene {
        DocumentGroup(viewing: BPXDocument.self) { file in
            ContentViewV2(object: BPXObject(document: file.$document))
                .environmentObject(globalState)
                .withErrorHandler()
        }
        .commands {
            CommandGroup(after: .newItem) {
                Divider()
                Button(action: { openBundleManagerWindow() }) { Text("Type description bundles") }
                Button(action: {
                    globalState.activeState?.showReInterpretMenu = true;
                }) { Text("Re-interpret as...") }.disabled(globalState.activeWindow == nil)
            }
        }
    }
}
