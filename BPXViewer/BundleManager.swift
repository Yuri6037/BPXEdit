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

struct TypeDesc: Codable {
    struct TypeDecl: Codable {
        enum FieldType: String, Codable {
            case unsigned
            case decimal
            case signed
            case enumeration
            case structure
            case structureArray
            case bitflags
            case stringPtr
            case bpxsdPtr
        }

        let type: FieldType
        let item: String?
        let section: UInt8?
        let size: UInt32
        let offset: UInt32
    }

    enum TypeVariant: Codable {
        case typeDesc(TypeDecl)
        case int(Int)

        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer();
            do {
                let val = try container.decode(TypeDecl.self);
                self = TypeVariant.typeDesc(val);
                
            } catch {
                let val = try container.decode(Int.self);
                self = TypeVariant.int(val);
            }
        }
    }

    let enableHexView: Bool?
    let global: TypeDecl
    let types: [String: [String: TypeVariant]]
}

struct Bundle {
    let main: BundleMain
    let typeDescs: [Int: TypeDesc]
}

fileprivate func tomlLoad<T: Codable>(path: String) throws -> T {
    let string = try String(contentsOfFile: path, encoding: String.Encoding.utf8);
    let obj = try TOMLDecoder().decode(T.self, from: string);
    return obj;
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
            let mainFile = result! + "/main.toml";
            let main = try tomlLoad(path: mainFile) as BundleMain; //Oh my... Not even able to directly instantiate a generic function! WTF!? Even rust can do this!!
            var typeDescs: [Int: TypeDesc] = [:]
            if let filename =  main.decoder {
                typeDescs[-1] = try tomlLoad(path: result! + "/" + filename);
            }
            for section in main.section {
                if let filename = section.decoder {
                    typeDescs[Int(section.code)] = try tomlLoad(path: result! + "/" + filename);
                }
            }
            map[main.code] = Bundle(main: main, typeDescs: typeDescs);
        }
    }

    func loadBundle(code: UInt8) {
        bundle = map[code];
    }

    func getBundle() -> Bundle? {
        return bundle;
    }
}
