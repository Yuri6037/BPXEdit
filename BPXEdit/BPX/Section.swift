//
//  Section.swift
//  BPXViewer
//
//  Created by Yuri Edwrad on 5/25/22.
//

import Foundation

fileprivate let BUF_SIZE = 8192;

public class SectionData: Reader {
    var inner: bpx_section_t?;
    var size: Int {
        if let inner = inner {
            return bpx_section_size(inner);
        } else {
            return 0;
        }
    }

    fileprivate init(inner: bpx_section_t?) {
        self.inner = inner;
    }

    public func loadInMemory() -> [uint8] {
        var block = [uint8](repeating: 0, count: size);
        var cursize = 0;
        bpx_section_seek(inner, 0);
        while cursize < size {
            block[cursize...].withUnsafeMutableBufferPointer { buffer in
                let len = bpx_section_read(inner, buffer.baseAddress, min(size - cursize, BUF_SIZE));
                cursize += len;
            };
        }
        return block;
    }

    public func read(size: Int) -> [uint8] {
        var block = [uint8](repeating: 0, count: size);
        let len = block.withUnsafeMutableBufferPointer { buffer in
            bpx_section_read(inner, buffer.baseAddress, size)
        };
        return Array(block[0..<len]);
    }

    public func seek(pos: UInt64) {
        bpx_section_seek(inner, pos);
    }

    public func readByte() -> uint8? {
        var byte: [uint8] = [0];
        let flag = byte.withUnsafeMutableBufferPointer { buffer in
            bpx_section_read(inner, buffer.baseAddress, 1) == 1
        };
        if !flag {
            return nil;
        }
        return byte[0];
    }

    public func write(_ buffer: [uint8]) -> Int {
        buffer.withUnsafeBufferPointer { ptr in
            bpx_section_write(inner, ptr.baseAddress, buffer.count)
        }
    }

    public func writeAppend(_ buffer: [uint8]) -> Int {
        buffer.withUnsafeBufferPointer { ptr in
            bpx_section_write_append(inner, ptr.baseAddress, buffer.count)
        }
    }

    public func remove(count: Int) {
        bpx_section_shift(inner, -Int64(count));
        bpx_section_truncate(inner, count, nil);
    }

    deinit {
        bpx_section_close(&inner);
    }
}

public class Section : Identifiable {
    public let handle: bpx_handle_t;
    public let index: Int;
    public let header: bpx_section_header_t;
    fileprivate let container: bpx_container_t?;

    init(handle: bpx_handle_t, index: Int, header: bpx_section_header_t, container: bpx_container_t?) {
        self.handle = handle;
        self.header = header;
        self.container = container;
        self.index = index;
    }

    public func open() throws -> SectionData {
        var data: bpx_section_t?;
        let err = bpx_section_open(container, handle, &data);
        if err != BPX_ERR_NONE {
            throw OpenError.fromc(code: err)!;
        }
        return SectionData(inner: data);
    }

    public func load() throws -> SectionData {
        var data: bpx_section_t?;
        let err = bpx_section_load(container, handle, &data);
        if err != BPX_ERR_NONE {
            throw CoreError.fromc(code: err)!;
        }
        return SectionData(inner: data);
    }
}
