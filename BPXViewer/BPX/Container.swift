//
//  Container.swift
//  BPXViewer
//
//  Created by Yuri Edwrad on 5/24/22.
//

import Foundation

public class Container {
    private var inner: bpx_container_t?;
    private var header: bpx_main_header_t = bpx_main_header_t();
    private var sections: [Section];

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
        for i in 0...Int(header.section_num) {
            var header = bpx_section_header_t();
            bpx_section_get_header(inner, handles[i], &header);
            sections.append(Section(handle: handles[i], header: header, container: inner));
        }
    }

    public func getSection(index: UInt32) -> Section {
        return sections[Int(index)];
    }

    public func getMainHeader() -> bpx_main_header_t {
        return header;
    }
}