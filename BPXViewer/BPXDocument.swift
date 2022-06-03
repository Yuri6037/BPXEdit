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
    //var error: String?;
    //var error: ErrorInfo?;

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

    mutating func loadSectionAsData(_ errorHost: ErrorHost, index: Int) -> [uint8]? {
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
            errorHost.spawn(ErrorInfo(message: String(describing: error)));
            return nil;
        }
    }

    mutating func decodeSection(_ errorHost: ErrorHost, index: Int) -> Value? {
        let data = loadSectionAsData(errorHost, index: index);
        guard let data = data else { return nil }
        let decoded: Value?;
        if index != -1 {
            let ty = container!.getSections()[index].header.ty;
            decoded = BundleManager.instance.getBundle()?.typeDescs[Int(ty)]?.decode(buffer: data);
        } else {
            decoded = BundleManager.instance.getBundle()?.typeDescs[index]?.decode(buffer: data);
        }
        if decoded == nil {
            errorHost.spawn(ErrorInfo(title: "Decode Error", message: "Unable to decode any object or array in the section."));
        }
        return decoded;
    }

    func isSectionDecodable(index: Int) -> Bool {
        if index != -1 {
            let ty = container!.getSections()[index].header.ty;
            return BundleManager.instance.getBundle()?.typeDescs[Int(ty)] != nil;
        } else {
            return BundleManager.instance.getBundle()?.typeDescs[index] != nil
        }
    }

    mutating func loadSectionAsStrings(_ errorHost: ErrorHost, index: Int) -> [String]? {
        do {
            let data = try container?.getSections()[index].load();
            return data?.loadStrings();
        } catch {
            errorHost.spawn(ErrorInfo(message: String(describing: error)));
            return nil;
        }
    }

    mutating func loadSectionAsSdValue(_ errorHost: ErrorHost, index: Int) -> SdValue? {
        do {
            let data = try container?.getSections()[index].load();
            data?.seek(pos: 0);
            return try data?.loadStructuredData();
        } catch {
            errorHost.spawn(ErrorInfo(message: String(describing: error)));
            return nil;
        }
    }
}
