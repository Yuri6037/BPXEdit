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
    var sections: [Section];

    static var readableContentTypes: [UTType] { [.exampleText] }

    init() {
        container = nil;
        sections = [];
    }

    init(configuration: ReadConfiguration) throws {
        let directory = NSTemporaryDirectory();
        let fileName = NSUUID().uuidString;
        guard let fileUrl = NSURL.fileURL(withPathComponents: [directory, fileName]) else { throw CocoaError(.fileReadNoPermission) };
        FileManager.default.createFile(atPath: fileUrl.path, contents: configuration.file.regularFileContents, attributes: nil);
        container = try Container(open: fileUrl.path);
        sections = container!.getSections();
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
}
