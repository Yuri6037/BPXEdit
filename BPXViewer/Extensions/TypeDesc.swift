//
//  TypeDesc.swift - The actual section decoder
//  BPXViewer
//
//  Created by Yuri Edwrad on 5/29/22.
//

import Foundation

struct TypeDesc: Codable {
    struct TypeDecl: Codable {
        enum FieldType: String, Codable {
            case unsigned
            case decimal
            case signed
            case bool
            case enumeration
            case structure
            case structureArray
            case bitflags
            case stringPtr
            case bpxsdPtr
        }

        let type: FieldType
        let item: String?
        let section: UInt8?
        let size: UInt32
        let offset: UInt32

        fileprivate func decodeInternal(buf: ByteBuf, types: [String: [String: TypeVariant]], baseOffset: Int) -> Value? {
            switch type {
            case .unsigned:
                buf.seek(pos: baseOffset + Int(offset));
                switch size {
                case 1:
                    guard let v = buf.readUInt8() else { return nil }
                    return .scalar(.u8(v));
                case 2:
                    guard let v = buf.readUInt16() else { return nil }
                    return .scalar(.u16(v));
                case 4:
                    guard let v = buf.readUInt32() else { return nil }
                    return .scalar(.u32(v));
                case 8:
                    guard let v = buf.readUInt64() else { return nil }
                    return .scalar(.u64(v));
                default:
                    return nil;
                }
            case .decimal:
                buf.seek(pos: baseOffset + Int(offset));
                switch size {
                case 4:
                    guard let v = buf.readFloat32() else { return nil }
                    return .scalar(.f32(v));
                case 8:
                    guard let v = buf.readFloat64() else { return nil }
                    return .scalar(.f64(v));
                default:
                    return nil;
                }
            case .signed:
                buf.seek(pos: baseOffset + Int(offset));
                switch size {
                case 1:
                    guard let v = buf.readInt8() else { return nil }
                    return .scalar(.i8(v));
                case 2:
                    guard let v = buf.readInt16() else { return nil }
                    return .scalar(.i16(v));
                case 4:
                    guard let v = buf.readInt32() else { return nil }
                    return .scalar(.i32(v));
                case 8:
                    guard let v = buf.readInt64() else { return nil }
                    return .scalar(.i64(v));
                default:
                    return nil;
                }
            case .bool:
                buf.seek(pos: baseOffset + Int(offset));
                switch size {
                case 1:
                    guard let v = buf.readUInt8() else { return nil }
                    return .scalar(.bool(v == 1 ? true : false));
                case 2:
                    guard let v = buf.readUInt16() else { return nil }
                    return .scalar(.bool(v == 1 ? true : false));
                case 4:
                    guard let v = buf.readUInt32() else { return nil }
                    return .scalar(.bool(v == 1 ? true : false));
                case 8:
                    guard let v = buf.readUInt64() else { return nil }
                    return .scalar(.bool(v == 1 ? true : false));
                default:
                    return nil;
                }
            case .enumeration:
                buf.seek(pos: baseOffset + Int(offset));
                let id: Int;
                switch size {
                case 1:
                    guard let v = buf.readUInt8() else { return nil }
                    id = Int(v);
                case 2:
                    guard let v = buf.readUInt16() else { return nil }
                    id = Int(v);
                case 4:
                    guard let v = buf.readUInt32() else { return nil }
                    id = Int(v);
                case 8:
                    guard let v = buf.readUInt64() else { return nil }
                    id = Int(v);
                default:
                    return nil;
                }
                guard let var1 = item, let enumeration = types[var1] else { return nil }
                for (name, value) in enumeration {
                    guard let value = value.asInt() else { return nil }
                    if value == id {
                        return .scalar(.string(name));
                    }
                }
                return .scalar(.string("Unknown"));
            case .structure:
                guard let var1 = item, let structure = types[var1] else { return nil }
                var fields: [String: Value] = [:]
                for (name, desc) in structure {
                    guard let desc = desc.asTypeDesc() else { return nil }
                    if let value = desc.decodeInternal(buf: buf, types: types, baseOffset: baseOffset + Int(offset)) {
                        fields[name] = value;
                    }
                }
                return .structure(fields);
            case .structureArray:
                let count = buf.size() / Int(size);
                var structs: [Value] = [];
                var offset = offset;
                for _ in 0..<count {
                    if let v = TypeDecl(type: .structure, item: item, section: section, size: size, offset: offset).decodeInternal(buf: buf, types: types, baseOffset: baseOffset) {
                        structs.append(v);
                    }
                    offset += size;
                }
                return .array(structs);
            case .bitflags:
                buf.seek(pos: baseOffset + Int(offset));
                let bits: Int;
                switch size {
                case 1:
                    guard let v = buf.readUInt8() else { return nil }
                    bits = Int(v);
                case 2:
                    guard let v = buf.readUInt16() else { return nil }
                    bits = Int(v);
                case 4:
                    guard let v = buf.readUInt32() else { return nil }
                    bits = Int(v);
                case 8:
                    guard let v = buf.readUInt64() else { return nil }
                    bits = Int(v);
                default:
                    return nil;
                }
                guard let var1 = item, let flags = types[var1] else { return nil }
                var flagStr = "";
                for (name, mask) in flags {
                    guard let mask = mask.asInt() else { return nil }
                    if bits & mask != 0 {
                        flagStr += " | " + name;
                    }
                }
                //Potentially super slow code but no other options despite my string to obviously be always ASCII characters, swift refuses at all costs to use an int directly! Let it be a good old Theta(n).
                flagStr = String(flagStr[flagStr.index(flagStr.startIndex, offsetBy: 2)...]);
                return .scalar(.string(flagStr));
            case .stringPtr, .bpxsdPtr:
                buf.seek(pos: baseOffset + Int(offset));
                switch size {
                case 1:
                    guard let v = buf.readUInt8() else { return nil }
                    return .scalar(.ptr8(v));
                case 2:
                    guard let v = buf.readUInt16() else { return nil }
                    return .scalar(.ptr16(v));
                case 4:
                    guard let v = buf.readUInt32() else { return nil }
                    return .scalar(.ptr32(v));
                case 8:
                    guard let v = buf.readUInt64() else { return nil }
                    return .scalar(.ptr64(v));
                default:
                    return nil;
                }
            }
        }
    }

    enum TypeVariant: Codable {
        case typeDesc(TypeDecl)
        case int(Int)

        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer();
            do {
                let val = try container.decode(TypeDecl.self);
                self = TypeVariant.typeDesc(val);
                
            } catch {
                let val = try container.decode(Int.self);
                self = TypeVariant.int(val);
            }
        }

        func asInt() -> Int? {
            switch self {
            case let .int(v):
                return v;
            default:
                return nil;
            }
        }

        func asTypeDesc() -> TypeDecl? {
            switch self {
            case let .typeDesc(v):
                return v;
            default:
                return nil;
            }
        }
    }

    let enableHexView: Bool?
    let global: TypeDecl
    let types: [String: [String: TypeVariant]]

    func decode(buffer: [uint8]) -> Value? {
        let buffer = ByteBuf(buffer: buffer);
        return global.decodeInternal(buf: buffer, types: types, baseOffset: 0);
    }
}
