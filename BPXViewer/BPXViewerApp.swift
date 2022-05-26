//
//  BPXViewerApp.swift
//  BPXViewer
//
//  Created by Yuri Edwrad on 5/23/22.
//

import SwiftUI

@main
struct BPXViewerApp: App {
    var body: some Scene {
        DocumentGroup(viewing: BPXDocument.self) { file in
            ContentView(document: file.$document)
        }
        .commands {
            CommandGroup(after: .newItem) {
                Divider()
                Button(action: {}) { Text("Import type description bundle") }
                Button(action: {}) { Text("Type description bundles") }
            }
        }
    }
}
