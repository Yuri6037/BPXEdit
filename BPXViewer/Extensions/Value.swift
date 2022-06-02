//
//  Value.swift - Decoded representation of a section
//  BPXViewer
//
//  Created by Yuri Edwrad on 5/29/22.
//

import Foundation

struct Pointer {
    enum Address {
        case p8(UInt8)
        case p16(UInt16)
        case p32(UInt32)
        case p64(UInt64)

        func toString() -> String {
            switch self {
            case .p8(let v):
                return String(format: "0x%02X", v);
            case .p16(let v):
                return String(format: "0x%04X", v);
            case .p32(let v):
                return String(format: "0x%08X", v);
            case .p64(let v):
                return String(format: "0x%16X", v);
            }
        }

        func as_u64() -> UInt64 {
            switch self {
            case .p8(let v):
                return UInt64(v)
            case .p16(let v):
                return UInt64(v)
            case .p32(let v):
                return UInt64(v)
            case .p64(let v):
                return UInt64(v)
            }
        }
    }

    enum EType {
        case string
        case bpxsd
    }

    let address: Address;
    let type: EType;
    let section: UInt8;
}

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
            }
        }

        func getTypeName() -> String {
            switch self {
            case .u8(_):
                return "Uint8";
            case .u16(_):
                return "Uint16";
            case .u32(_):
                return "Uint32";
            case .u64(_):
                return "Uint64";
            case .i8(_):
                return "Int8";
            case .i16(_):
                return "Int16";
            case .i32(_):
                return "Int32";
            case .i64(_):
                return "Int64";
            case .bool(_):
                return "Bool";
            case .f32(_):
                return "Float";
            case .f64(_):
                return "Double";
            case .string(_):
                return "String";
            }
        }
    }

    case scalar(Scalar)
    case structure([String: Value])
    case array([Value])
    case pointer(Pointer)
}
