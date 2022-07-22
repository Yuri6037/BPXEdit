//
//  SdValueModel.swift
//  BPXViewer
//
//  Created by Yuri Edwrad on 7/10/22.
//

import Foundation
import SwiftUI

//Attempt to use a formatter.

enum SdDataType: String, Identifiable, CaseIterable {
    var id: String { self.rawValue }

    case array = "Array"
    case object = "Object"
    case uint8 = "UInt8"
    case int8 = "Int8"
    case uint16 = "UInt16"
    case int16 = "Int16"
    case uint32 = "UInt32"
    case int32 = "Int32"
    case uint64 = "UInt64"
    case int64 = "Int64"
    case float = "Float32"
    case double = "Float64"
    case bool = "Bool"
    case string = "String"

    func getNumberType() -> NumberType? {
        switch self {
        case .uint8:
            return .u8;
        case .int8:
            return .i8;
        case .uint16:
            return .u16;
        case .int16:
            return .i16;
        case .uint32:
            return .u32;
        case .int32:
            return .i32;
        case .uint64:
            return .u64;
        case .int64:
            return .i64;
        case .float:
            return .f32;
        case .double:
            return .f64;
        default:
            return nil;
        }
    }

    func hasChildren() -> Bool {
        switch self {
        case .array:
            return true;
        case .object:
            return true;
        default:
            return false;
        }
    }

    func validate(value: String) -> String {
        switch self {
        case .uint8:
            return UInt8.validate(context: (), value: value);
        case .int8:
            return Int8.validate(context: (), value: value);
        case .uint16:
            return UInt16.validate(context: (), value: value);
        case .int16:
            return Int16.validate(context: (), value: value);
        case .uint32:
            return UInt32.validate(context: (), value: value);
        case .int32:
            return Int32.validate(context: (), value: value);
        case .uint64:
            return UInt64.validate(context: (), value: value);
        case .int64:
            return Int64.validate(context: (), value: value);
        case .float:
            return Float32.validate(value: value);
        case .double:
            return Float64.validate(value: value);
        case .bool:
            return (value != "true" && value != "false") ? "false" : value;
        default:
            return value;
        }
    }
}

extension AnyNumber {
    func toScalar() -> Value.Scalar {
        switch self {
        case .u8(let v):
            return .u8(v);
        case .u16(let v):
            return .u16(v);
        case .u32(let v):
            return .u32(v);
        case .u64(let v):
            return .u64(v);
        case .i8(let v):
            return .i8(v);
        case .i16(let v):
            return .i16(v);
        case .i32(let v):
            return .i32(v);
        case .i64(let v):
            return .i64(v);
        case .f32(let v):
            return .f32(v);
        case .f64(let v):
            return .f64(v);
        }
    }
}

class SdValueModel: ObservableObject {
    @Published var dataType: SdDataType = .string {
        didSet {
            if let num = dataType.getNumberType() {
                number = num.new();
            }
        }
    }

    @Published var string: String = "";

    @Published var number: AnyNumber = .u8(0);

    @Published var bool = false;

    var valueData: Value.Scalar? {
        switch dataType {
        case .array:
            return nil;
        case .object:
            return nil;
        case .bool:
            return .bool(bool);
        case .string:
            return .string(string);
        default:
            return number.toScalar();
        }
    }
}
