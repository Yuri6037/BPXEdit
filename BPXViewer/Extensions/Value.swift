//
//  Value.swift - Decoded representation of a section
//  BPXViewer
//
//  Created by Yuri Edwrad on 5/29/22.
//

import Foundation

enum Value {
    enum Scalar {
        case u8(UInt8)
        case u16(UInt16)
        case u32(UInt32)
        case u64(UInt64)
        case i8(Int8)
        case i16(Int16)
        case i32(Int32)
        case i64(Int64)
        case bool(Bool)
        case f32(Float32)
        case f64(Float64)
        case string(String)
        case ptr8(UInt8)
        case ptr16(UInt16)
        case ptr32(UInt32)
        case ptr64(UInt64)

        func toString() -> String {
            switch self {
            case .u8(let v):
                return v.formatted()
            case .u16(let v):
                return v.formatted()
            case .u32(let v):
                return v.formatted()
            case .u64(let v):
                return String(v)
            case .i8(let v):
                return v.formatted()
            case .i16(let v):
                return v.formatted()
            case .i32(let v):
                return v.formatted()
            case .i64(let v):
                return v.formatted()
            case .bool(let v):
                return v ? "On" : "Off";
            case .f32(let v):
                return v.formatted()
            case .f64(let v):
                return v.formatted()
            case .string(let v):
                return v;
            case .ptr8(let v):
                return String(format: "0x%02X", v);
            case .ptr16(let v):
                return String(format: "0x%04X", v);
            case .ptr32(let v):
                return String(format: "0x%08X", v);
            case .ptr64(let v):
                return String(format: "0x%16X", v);
            }
        }
    }

    case scalar(Scalar)
    case structure([String: Value])
    case array([Value])
}
