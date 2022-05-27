//
//  BPXViewerApp.swift
//  BPXViewer
//
//  Created by Yuri Edwrad on 5/23/22.
//

import SwiftUI

extension String: Identifiable {
    public typealias ID = Int
    public var id: Int {
        return hash
    }
}

@main
struct BPXViewerApp: App {
    @State var error: String?;

    var body: some Scene {
        DocumentGroup(viewing: BPXDocument.self) { file in
            ContentView(document: file.$document)
                .alert(item: $error) { error in Alert(title: Text("Error importing bundle"), message: Text(error)) }
        }
        .commands {
            CommandGroup(after: .newItem) {
                Divider()
                Button(action: {
                    do {
                        try BundleManager.instance.importBundle()
                    } catch {
                        self.error = error.localizedDescription;
                    }
                }) { Text("Import type description bundle") }
                Button(action: {}) { Text("Type description bundles") }
            }
        }
    }
}
