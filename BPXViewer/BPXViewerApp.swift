//
//  BPXViewerApp.swift
//  BPXViewer
//
//  Created by Yuri Edwrad on 5/23/22.
//

import SwiftUI

@main
struct BPXViewerApp: App {
    init() {
        if BundleManager.instance.isErrored() {
            openBundleManagerWindow()
        }
    }

    var body: some Scene {
        DocumentGroup(viewing: BPXDocument.self) { file in
            ContentView(document: file.$document)
                .withErrorHandler()
        }
        .commands {
            CommandGroup(after: .newItem) {
                Divider()
                Button(action: { openBundleManagerWindow() }) { Text("Type description bundles") }
            }
        }
    }
}
