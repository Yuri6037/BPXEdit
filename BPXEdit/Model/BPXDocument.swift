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
    var filePath: URL?;
    var sections: [Section];

    static var readableContentTypes: [UTType] { [.exampleText] }

    init() {
        container = nil;
        sections = [];
        filePath = nil;
    }

    init(configuration: ReadConfiguration) throws {
        let directory = NSTemporaryDirectory();
        let fileName = NSUUID().uuidString;
        guard let fileUrl = NSURL.fileURL(withPathComponents: [directory, fileName]) else { throw CocoaError(.fileReadNoPermission) };
        try configuration.file.regularFileContents?.write(to: fileUrl, options: Data.WritingOptions.noFileProtection);
        container = try Container(open: fileUrl.path);
        try container?.save();
        sections = container!.getSections();
        filePath = fileUrl;
    }

    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        if let container = container {
            try container.save();
            return try FileWrapper(url: filePath!);
        }
        
        throw CocoaError(.fileNoSuchFile)
    }

    func findBundle() -> Bundle? {
        if let container = container {
            return BundleManager.instance.findBundle(code: container.getMainHeader().ty);
        }
        return nil;
    }
}
