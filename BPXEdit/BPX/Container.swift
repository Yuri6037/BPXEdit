//
//  Container.swift
//  BPXViewer
//
//  Created by Yuri Edwrad on 5/24/22.
//

import Foundation

public class Container {
    fileprivate var inner: bpx_container_t?;
    fileprivate var header: bpx_main_header_t = bpx_main_header_t();
    fileprivate var sections: [Section];

    public init(open: String) throws {
        let err = bpx_container_open(open, &inner);
        if err != BPX_ERR_NONE {
            throw CoreError.fromc(code: err)!;
        }
        bpx_container_get_main_header(inner, &header);
        sections = [];
        sections.reserveCapacity(Int(header.section_num));
        var handles = [bpx_handle_t](repeating: 0, count: Int(header.section_num));
        handles.withUnsafeMutableBufferPointer { buffer in
            bpx_container_list_sections(inner, buffer.baseAddress, Int(header.section_num));
        }
        for (index, handle) in handles.enumerated() {
            var header = bpx_section_header_t();
            bpx_section_get_header(inner, handle, &header);
            sections.append(Section(handle: handle, index: index, header: header, container: inner));
        }
    }

    deinit {
        bpx_container_close(&inner);
    }

    public func getSections() -> [Section] {
        return sections;
    }

    public func removeSection(index: Int) {
        let handle = sections[index].handle;
        sections.remove(at: index)
        for i in index..<sections.count {
            let sec = sections[i]
            sections[i] = Section(handle: sec.handle, index: i, header: sec.header, container: inner);
        }
        bpx_container_remove_section(inner, handle);
    }

    public func getMainHeader() -> bpx_main_header_t {
        return header;
    }

    public func save() throws {
        let err = bpx_container_save(inner);
        if err != BPX_ERR_NONE {
            throw CoreError.fromc(code: err)!;
        }
    }

    public func getSectionByType(type: UInt8) -> Section? {
        for section in sections {
            if section.header.ty == type {
                return section;
            }
        }
        return nil;
    }
}
