//
//  Pointer.swift
//  BPXViewer
//
//  Created by Yuri Edwrad on 6/2/22.
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
