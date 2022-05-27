//
//  ByteBuf.swift
//  BPXViewer
//
//  Created by Yuri Edwrad on 5/27/22.
//

import Foundation
import AppKit

class ByteBuf {
    private let buffer: [uint8]
    private var cursor = 0;

    init(buffer: [uint8]) {
        self.buffer = buffer;
    }

    private func checkValidSize(len: Int) -> Bool {
        if buffer.count - cursor < len {
            return false;
        } else {
            return true;
        }
    }

    func seek(pos: Int) {
        cursor = pos;
    }

    func readInt8() -> Int8? {
        if !checkValidSize(len: 1) {
            return nil;
        }
        let val = Int8(buffer[cursor]);
        cursor += 1;
        return val;
    }

    func readInt16() -> Int16? {
        if !checkValidSize(len: 2) {
            return nil;
        }
        let val = buffer[cursor...cursor + 2].withUnsafeBufferPointer() { ptr in
            ptr.baseAddress!.withMemoryRebound(to: Int16.self, capacity: 1) { $0 }.pointee
        };
        cursor += 2;
        return val;
    }

    func readInt32() -> Int32? {
        if !checkValidSize(len: 4) {
            return nil;
        }
        let val = buffer[cursor...cursor + 4].withUnsafeBufferPointer() { ptr in
            ptr.baseAddress!.withMemoryRebound(to: Int32.self, capacity: 1) { $0 }.pointee
        };
        cursor += 4;
        return val;
    }

    func readInt64() -> Int64? {
        if !checkValidSize(len: 8) {
            return nil;
        }
        let val = buffer[cursor...cursor + 8].withUnsafeBufferPointer() { ptr in
            ptr.baseAddress!.withMemoryRebound(to: Int64.self, capacity: 1) { $0 }.pointee
        };
        cursor += 8;
        return val;
    }

    func readUInt8() -> UInt8? {
        if !checkValidSize(len: 1) {
            return nil;
        }
        let val = UInt8(buffer[cursor]);
        cursor += 1;
        return val;
    }

    func readUInt16() -> UInt16? {
        if !checkValidSize(len: 2) {
            return nil;
        }
        let val = buffer[cursor...cursor + 2].withUnsafeBufferPointer() { ptr in
            ptr.baseAddress!.withMemoryRebound(to: UInt16.self, capacity: 1) { $0 }.pointee
        };
        cursor += 2;
        return val;
    }

    func readUInt32() -> UInt32? {
        if !checkValidSize(len: 4) {
            return nil;
        }
        let val = buffer[cursor...cursor + 4].withUnsafeBufferPointer() { ptr in
            ptr.baseAddress!.withMemoryRebound(to: UInt32.self, capacity: 1) { $0 }.pointee
        };
        cursor += 4;
        return val;
    }

    func readUInt64() -> UInt64? {
        if !checkValidSize(len: 8) {
            return nil;
        }
        let val = buffer[cursor...cursor + 8].withUnsafeBufferPointer() { ptr in
            ptr.baseAddress!.withMemoryRebound(to: UInt64.self, capacity: 1) { $0 }.pointee
        };
        cursor += 8;
        return val;
    }

    func readFloat32() -> Float32? {
        if !checkValidSize(len: 4) {
            return nil;
        }
        let val = buffer[cursor...cursor + 4].withUnsafeBufferPointer() { ptr in
            ptr.baseAddress!.withMemoryRebound(to: Float32.self, capacity: 1) { $0 }.pointee
        };
        cursor += 4;
        return val;
    }

    func readFloat64() -> Float64? {
        if !checkValidSize(len: 8) {
            return nil;
        }
        let val = buffer[cursor...cursor + 8].withUnsafeBufferPointer() { ptr in
            ptr.baseAddress!.withMemoryRebound(to: Float64.self, capacity: 1) { $0 }.pointee
        };
        cursor += 8;
        return val;
    }
}
