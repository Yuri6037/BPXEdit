//
//  Section.swift
//  BPXViewer
//
//  Created by Yuri Edwrad on 5/25/22.
//

import Foundation

public class Section {
    public let handle: bpx_handle_t;
    public let header: bpx_section_header_t;
    private let container: bpx_container_t?;

    init(handle: bpx_handle_t, header: bpx_section_header_t, container: bpx_container_t?) {
        self.handle = handle;
        self.header = header;
        self.container = container;
    }

    public func open() throws {
        var data: bpx_section_t?;
        let err = bpx_section_open(container, handle, &data);
        if err != BPX_ERR_NONE {
            throw OpenError.fromc(code: err)!;
        }
    }
}
