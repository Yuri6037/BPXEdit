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

struct Bundle: BypassHashable {
    let id: UUID
    let date: Date
    let main: BundleMain
    let typeDescs: [Int: TypeDesc]
}

struct UUIDParseError : Error {}

class BundleManager {
    private var map: [UInt8: Bundle] = [:];
    private var list: [Bundle] = [];
    private var lastError: ErrorInfo?;

    fileprivate func register(bundle: Bundle) {
        list.append(bundle);
        if map[bundle.main.code] == nil {
            map[bundle.main.code] = bundle;
        }
    }

    func isErrored() -> Bool {
        return lastError != nil
    }

    func getLastError() -> ErrorInfo? {
        let err = lastError;
        lastError = nil;
        return err;
    }

    func getBundles() -> [Bundle] {
        return list;
    }

    fileprivate init() {
        do {
            let cache = try getCache();
            let files = try FileManager.default.contentsOfDirectory(at: cache, includingPropertiesForKeys: [.contentModificationDateKey], options: .skipsHiddenFiles);
            for file in files {
                if file.pathExtension == "bundle" {
                    let fileNameWithExt = file.lastPathComponent;
                    let fileName = fileNameWithExt.slice(0, fileNameWithExt.count - 8);
                    guard let uuid = UUID(uuidString: fileName) else { throw UUIDParseError() }
                    let date = try file.resourceValues(forKeys: [.contentModificationDateKey]).contentModificationDate!;
                    let bundle = try loadBundle(path: file.path, id: uuid, date: date);
                    register(bundle: bundle);
                }
            }
        } catch {
            lastError = ErrorInfo(title: "Bundle Error", message: String(describing: error), context: "BundleManager Initialization");
        }
    }

    static let instance = BundleManager();

    fileprivate func getCache() throws -> URL {
        let url = try FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true);
        return url;
    }

    func install(path: String) -> Bundle? {
        do {
            let bundle = try loadBundle(path: path);
            let cache = try getCache();
            let outDir = cache.path + "/" + bundle.id.uuidString + ".bundle";
            try FileManager.default.copyItem(atPath: path, toPath: outDir);
            register(bundle: bundle);
            return bundle;
        } catch {
            lastError = ErrorInfo(title: "Bundle Error", message: String(describing: error), context: "Bundle Installation");
        }
        return nil;
    }

    func uninstall(bundle: Bundle) {
        do {
            let path = try getCache();
            try FileManager.default.removeItem(atPath: path.path + "/" + bundle.id.uuidString + ".bundle");
            list.removeAll(where: { v in v.id == bundle.id });
            if map[bundle.main.code] != nil && map[bundle.main.code]!.id == bundle.id {
                map.removeValue(forKey: bundle.main.code);
            }
        } catch {
            lastError = ErrorInfo(title: "Bundle Error", message: String(describing: error), context: "Bundle Uninstallation");
        }
    }

    func findBundle(code: UInt8) -> Bundle? {
        return map[code];
    }
}
