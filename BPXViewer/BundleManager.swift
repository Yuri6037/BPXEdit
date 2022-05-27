//
//  BundleManager.swift
//  BPXViewer
//
//  Created by Yuri Edwrad on 5/27/22.
//

import Foundation
import AppKit
import UniformTypeIdentifiers
import TOMLDecoder

struct BundleMain: Codable
{
    struct Section: Codable {
        let code: UInt8
        let name: String
    }

    let code: UInt8
    let name: String
    let section: [Section]
}

struct Bundle {
    let main: BundleMain
}

class BundleManager {
    private var map: [UInt8: Bundle] = [:];

    private init() {}

    static let instance = BundleManager();

    func importBundle() throws {
        let dialog = NSOpenPanel();
        dialog.title = "Choose a bundle to import.";
        dialog.showsResizeIndicator = true;
        dialog.showsHiddenFiles = false;
        dialog.canChooseDirectories = false;
        dialog.canCreateDirectories = false;
        dialog.allowsMultipleSelection = false;
        dialog.allowedContentTypes = [UTType(filenameExtension: "bundle", conformingTo: .package)!];
        if (dialog.runModal() == NSApplication.ModalResponse.OK) {
            let result = dialog.url?.path;
            let mainFile = result! + "/main.toml";
            let string = try String(contentsOfFile: mainFile, encoding: String.Encoding.utf8);
            let obj = try TOMLDecoder().decode(BundleMain.self, from: string);
            map[obj.code] = Bundle(main: obj);
        }
    }
}
