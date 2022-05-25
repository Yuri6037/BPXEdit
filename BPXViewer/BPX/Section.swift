//
//  Section.swift
//  BPXViewer
//
//  Created by Yuri Edwrad on 5/25/22.
//

import Foundation

fileprivate let BUF_SIZE = 8192;

public class SectionData {
    fileprivate var inner: bpx_section_t?;
    let size: Int;

    fileprivate init(inner: bpx_section_t?, size: Int) {
        self.inner = inner;
        self.size = size;
    }

    public func loadInMemory() -> [uint8] {
        var block = [uint8](repeating: 0, count: size);
        var cursize = 0;
        bpx_section_seek(inner, 0);
        while cursize < size {
            block[cursize...].withUnsafeMutableBufferPointer { buffer in
                let len = bpx_section_read(inner, buffer.baseAddress, BUF_SIZE);
                cursize += len;
            };
        }
        return block;
    }

    deinit {
        bpx_section_close(&inner);
    }
}

public class Section {
    public let handle: bpx_handle_t;
    public let header: bpx_section_header_t;
    private let container: bpx_container_t?;

    init(handle: bpx_handle_t, header: bpx_section_header_t, container: bpx_container_t?) {
        self.handle = handle;
        self.header = header;
        self.container = container;
    }

    public func open() throws -> SectionData {
        var data: bpx_section_t?;
        let err = bpx_section_open(container, handle, &data);
        if err != BPX_ERR_NONE {
            throw OpenError.fromc(code: err)!;
        }
        return SectionData(inner: data, size: Int(header.size));
    }

    public func load() throws -> SectionData {
        var data: bpx_section_t?;
        let err = bpx_section_load(container, handle, &data);
        if err != BPX_ERR_NONE {
            throw CoreError.fromc(code: err)!;
        }
        return SectionData(inner: data, size: Int(header.size));
    }
}
