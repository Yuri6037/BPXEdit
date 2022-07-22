//
//  AnyNumber.swift
//  BPXViewer
//
//  Created by Yuri Edwrad on 7/15/22.
//

import Foundation

enum NumberType {
    case u8
    case u16
    case u32
    case u64
    case i8
    case i16
    case i32
    case i64
    case f32
    case f64

    func new() -> AnyNumber {
        switch self {
        case .u8:
            return .u8(0)
        case .u16:
            return .u16(0)
        case .u32:
            return .u32(0)
        case .u64:
            return .u64(0)
        case .i8:
            return .i8(0)
        case .i16:
            return .i16(0)
        case .i32:
            return .i32(0)
        case .i64:
            return .i64(0)
        case .f32:
            return .f32(0)
        case .f64:
            return .f64(0)
        }
    }
}

enum AnyNumber: Number {
    case u8(UInt8)
    case u16(UInt16)
    case u32(UInt32)
    case u64(UInt64)
    case i8(Int8)
    case i16(Int16)
    case i32(Int32)
    case i64(Int64)
    case f32(Float32)
    case f64(Float64)

    typealias Context = NumberType;

    mutating func increment() {
        switch self {
        case .u8(var v):
            v.increment()
        case .u16(var v):
            v.increment()
        case .u32(var v):
            v.increment()
        case .u64(var v):
            v.increment()
        case .i8(var v):
            v.increment()
        case .i16(var v):
            v.increment()
        case .i32(var v):
            v.increment()
        case .i64(var v):
            v.increment()
        case .f32(var v):
            v.increment()
        case .f64(var v):
            v.increment()
        }
    }
    
    mutating func decrement() {
        switch self {
        case .u8(var v):
            v.decrement()
        case .u16(var v):
            v.decrement()
        case .u32(var v):
            v.decrement()
        case .u64(var v):
            v.decrement()
        case .i8(var v):
            v.decrement()
        case .i16(var v):
            v.decrement()
        case .i32(var v):
            v.decrement()
        case .i64(var v):
            v.decrement()
        case .f32(var v):
            v.decrement()
        case .f64(var v):
            v.decrement()
        }
    }

    static func toNumber(context: NumberType, string: String) -> AnyNumber {
        switch context {
        case .u8:
            return .u8(.toNumber(context: (), string: string));
        case .u16:
            return .u16(.toNumber(context: (), string: string));
        case .u32:
            return .u32(.toNumber(context: (), string: string));
        case .u64:
            return .u64(.toNumber(context: (), string: string));
        case .i8:
            return .i8(.toNumber(context: (), string: string));
        case .i16:
            return .i16(.toNumber(context: (), string: string));
        case .i32:
            return .i32(.toNumber(context: (), string: string));
        case .i64:
            return .i64(.toNumber(context: (), string: string));
        case .f32:
            return .f32(.toNumber(context: (), string: string));
        case .f64:
            return .f64(.toNumber(context: (), string: string));
        }
    }

    static func validate(context: NumberType, value: String) -> String {
        switch context {
        case .u8:
            return UInt8.validate(context: (), value: value);
        case .u16:
            return UInt16.validate(context: (), value: value);
        case .u32:
            return UInt32.validate(context: (), value: value);
        case .u64:
            return UInt64.validate(context: (), value: value);
        case .i8:
            return Int8.validate(context: (), value: value);
        case .i16:
            return Int16.validate(context: (), value: value);
        case .i32:
            return Int32.validate(context: (), value: value);
        case .i64:
            return Int64.validate(context: (), value: value);
        case .f32:
            return Float32.validate(context: (), value: value);
        case .f64:
            return Float64.validate(context: (), value: value);
        }
    }

    func toString() -> String {
        switch self {
        case .u8(let v):
            return v.formatted();
        case .u16(let v):
            return v.formatted();
        case .u32(let v):
            return v.formatted();
        case .u64(let v):
            return String(v);
        case .i8(let v):
            return v.formatted();
        case .i16(let v):
            return v.formatted();
        case .i32(let v):
            return v.formatted();
        case .i64(let v):
            return v.formatted();
        case .f32(let v):
            return v.formatted();
        case .f64(let v):
            return v.formatted();
        }
    }
}
