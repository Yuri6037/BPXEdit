//
//  BundleManager.swift
//  BPXViewer
//
//  Created by Yuri Edwrad on 5/27/22.
//

import Foundation
import AppKit
import UniformTypeIdentifiers

struct BundleMain: Codable {
    struct Section: Codable {
        let code: UInt8
        let name: String
        let decoder: String?
    }

    let code: UInt8
    let name: String
    let section: [Section]
    let decoder: String?

    func getSectionName(code: UInt8) -> String? {
        for section in section {
            if section.code == code {
                return section.name;
            }
        }
        return nil;
    }
}

struct Bundle {
    let main: BundleMain
    let typeDescs: [Int: TypeDesc]
}

class BundleManager {
    private var map: [UInt8: Bundle] = [:];
    private var bundle: Bundle?;

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
            let bundle = try loadBundle(path: result!);
            map[bundle.main.code] = bundle;
        }
    }

    func bindBundle(code: UInt8) {
        bundle = map[code];
    }

    func getBundle() -> Bundle? {
        return bundle;
    }
}
