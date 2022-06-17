//
//  BPXViewerDocument.swift
//  BPXViewer
//
//  Created by Yuri Edwrad on 5/23/22.
//

import SwiftUI
import UniformTypeIdentifiers

extension UTType {
    static var exampleText: UTType {
        UTType(exportedAs: "com.gitlab.bp3d.BPX", conformingTo: nil)
    }
}

struct BPXDocument: FileDocument {
    var container: Container?;

    static var readableContentTypes: [UTType] { [.exampleText] }

    init() {
        container = nil;
    }

    init(configuration: ReadConfiguration) throws {
        let directory = NSTemporaryDirectory();
        let fileName = NSUUID().uuidString;
        guard let fileUrl = NSURL.fileURL(withPathComponents: [directory, fileName]) else { throw CocoaError(.fileReadNoPermission) };
        FileManager.default.createFile(atPath: fileUrl.path, contents: configuration.file.regularFileContents, attributes: nil);
        container = try Container(open: fileUrl.path);
    }

    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        throw CocoaError(.fileWriteNoPermission)
    }

    func findBundle() -> Bundle? {
        if let container = container {
            return BundleManager.instance.findBundle(code: container.getMainHeader().ty);
        }
        return nil;
    }

    func loadRaw(errorHost: ErrorHost, section: Int) -> [uint8]? {
        if section == -1 {
            var useless = container?.getMainHeader().type_ext;
            let buffer = withUnsafeBytes(of: &useless) { (rawptr) in
                Array(rawptr)
            };
            return buffer;
        }
        do {
            let data = try container?.getSections()[section].load();
            return data?.loadInMemory();
        } catch {
            errorHost.spawn(ErrorInfo(message: String(describing: error), context: "Hex View"));
            return nil;
        }
    }

    func loadData(errorHost: ErrorHost, section: Int, bundle: Bundle) -> Value? {
        let data = loadRaw(errorHost: errorHost, section: section);
        guard let data = data else { return nil }
        let decoded: Value?;
        if section != -1 {
            let ty = container!.getSections()[section].header.ty;
            decoded = bundle.typeDescs[Int(ty)]?.decode(buffer: data);
        } else {
            decoded = bundle.typeDescs[-1]?.decode(buffer: data); //Type declaration -1 is always BPX Extended Data.
        }
        if decoded == nil {
            errorHost.spawn(ErrorInfo(title: "Decode Error", message: "Unable to decode any object or array in the section.", context: "Data View"));
        }
        return decoded;
    }

    func canDecode(section: Int, bundle: Bundle) -> Bool {
        if section != -1 {
            let ty = container!.getSections()[section].header.ty;
            return bundle.typeDescs[Int(ty)] != nil;
        } else {
            return bundle.typeDescs[-1] != nil
        }
    }

    func loadStrings(errorHost: ErrorHost, section: Int) -> [String]? {
        do {
            let data = try container?.getSections()[section].load();
            return data?.loadStrings();
        } catch {
            errorHost.spawn(ErrorInfo(message: String(describing: error), context: "Strings View"));
            return nil;
        }
    }

    func loadStructuredData(errorHost: ErrorHost, section: Int) -> SdValue? {
        do {
            let data = try container?.getSections()[section].load();
            data?.seek(pos: 0);
            return try data?.loadStructuredData();
        } catch {
            errorHost.spawn(ErrorInfo(message: String(describing: error), context: "BPXSD View"));
            return nil;
        }
    }
}
