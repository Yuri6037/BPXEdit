//
//  BPXObject.swift
//  BPXViewer
//
//  Created by Yuri Edwrad on 6/18/22.
//

import Foundation
import SwiftUI

class BPXObject: ObservableObject {
    @Binding var document: BPXDocument;
    @Published var bundle: Bundle?;
    @Published var sections: [Section]

    init(document: Binding<BPXDocument>) {
        _document = document;
        //Pre-initialize with wrong values.
        bundle = nil;
        sections = [];
        //Now call the proper functions which cannot be called directly on a Binding<>.
        bundle = self.document.findBundle();
        sections = self.document.container?.getSections() ?? [];
    }

    convenience init() {
        self.init(document: .constant(BPXDocument()))
        bundle = nil;
    }

    func remove(section: Int) {
        document.container?.removeSection(index: section);
        sections = document.container?.getSections() ?? [];
    }

    func loadSection(errorHost: ErrorHost, section: Int) -> SectionData? {
        if section == -1 {
            return nil;
        }
        do {
            let data = try document.container?.getSections()[section].load();
            return data;
        } catch {
            errorHost.spawn(ErrorInfo(message: String(describing: error), context: "Hex View"));
            return nil;
        }
    }

    func loadRaw(errorHost: ErrorHost, section: Int) -> [uint8]? {
        if section == -1 {
            var useless = document.container?.getMainHeader().type_ext;
            let buffer = withUnsafeBytes(of: &useless) { (rawptr) in
                Array(rawptr)
            };
            return buffer;
        }
        do {
            let data = try document.container?.getSections()[section].load();
            return data?.loadInMemory();
        } catch {
            errorHost.spawn(ErrorInfo(message: String(describing: error), context: "Hex View"));
            return nil;
        }
    }

    func loadData(errorHost: ErrorHost, section: Int) -> Value? {
        let data = loadRaw(errorHost: errorHost, section: section);
        guard let data = data else { return nil }
        let decoded: Value?;
        if section != -1 {
            let ty = document.container!.getSections()[section].header.ty;
            decoded = bundle?.typeDescs[Int(ty)]?.decode(buffer: data);
        } else {
            decoded = bundle?.typeDescs[-1]?.decode(buffer: data); //Type declaration -1 is always BPX Extended Data.
        }
        if decoded == nil {
            errorHost.spawn(ErrorInfo(title: "Decode Error", message: "Unable to decode any object or array in the section.", context: "Data View"));
        }
        return decoded;
    }

    func isValid(section: Int) -> Bool {
        return sections.indices.contains(section);
    }

    func canDecode(section: Int) -> Bool {
        if section != -1 {
            let ty = document.container!.getSections()[section].header.ty;
            return bundle?.typeDescs[Int(ty)] != nil;
        } else {
            return bundle?.typeDescs[-1] != nil
        }
    }

    func loadStrings(errorHost: ErrorHost, section: Int) -> [String]? {
        do {
            let data = try document.container?.getSections()[section].load();
            return data?.loadStrings();
        } catch {
            errorHost.spawn(ErrorInfo(message: String(describing: error), context: "Strings View"));
            return nil;
        }
    }

    func loadStructuredData(errorHost: ErrorHost, section: Int) -> SdValue? {
        do {
            let data = try document.container?.getSections()[section].load();
            data?.seek(pos: 0);
            return try data?.loadStructuredData();
        } catch {
            errorHost.spawn(ErrorInfo(message: String(describing: error), context: "BPXSD View"));
            return nil;
        }
    }

}
