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
        BundleManager.instance.bindBundle(code: container!.getMainHeader().ty);
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

    func loadSectionAsData(_ errorHost: ErrorHost, index: Int) -> [uint8]? {
        if index == -1 {
            var useless = container?.getMainHeader().type_ext;
            let buffer = withUnsafeBytes(of: &useless) { (rawptr) in
                Array(rawptr)
            };
            return buffer;
        }
        do {
            let data = try container?.getSections()[index].load();
            return data?.loadInMemory();
        } catch {
            errorHost.spawn(ErrorInfo(message: String(describing: error), context: "Hex View"));
            return nil;
        }
    }

    func decodeSection(_ errorHost: ErrorHost, index: Int, bundle: Bundle) -> Value? {
        let data = loadSectionAsData(errorHost, index: index);
        guard let data = data else { return nil }
        let decoded: Value?;
        if index != -1 {
            let ty = container!.getSections()[index].header.ty;
            decoded = bundle.typeDescs[Int(ty)]?.decode(buffer: data);
        } else {
            decoded = bundle.typeDescs[index]?.decode(buffer: data);
        }
        if decoded == nil {
            errorHost.spawn(ErrorInfo(title: "Decode Error", message: "Unable to decode any object or array in the section.", context: "Data View"));
        }
        return decoded;
    }

    func isSectionDecodable(index: Int, bundle: Bundle) -> Bool {
        if index != -1 {
            let ty = container!.getSections()[index].header.ty;
            return bundle.typeDescs[Int(ty)] != nil;
        } else {
            return bundle.typeDescs[index] != nil
        }
    }

    func loadSectionAsStrings(_ errorHost: ErrorHost, index: Int) -> [String]? {
        do {
            let data = try container?.getSections()[index].load();
            return data?.loadStrings();
        } catch {
            errorHost.spawn(ErrorInfo(message: String(describing: error), context: "Strings View"));
            return nil;
        }
    }

    func loadSectionAsSdValue(_ errorHost: ErrorHost, index: Int) -> SdValue? {
        do {
            let data = try container?.getSections()[index].load();
            data?.seek(pos: 0);
            return try data?.loadStructuredData();
        } catch {
            errorHost.spawn(ErrorInfo(message: String(describing: error), context: "BPXSD View"));
            return nil;
        }
    }
}
