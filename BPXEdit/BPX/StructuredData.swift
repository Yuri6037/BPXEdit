//
//  StructuredData.swift
//  BPXViewer
//
//  Created by Yuri Edwrad on 5/30/22.
//

import Foundation

fileprivate func decodeValue(name: SdValue.Name?, value: bpx_sd_value_t) -> SdValue? {
    switch value.type {
    case BPX_SD_VALUE_TYPE_NULL:
        return SdValue(name: name);
    case BPX_SD_VALUE_TYPE_BOOL:
        return SdValue(name: name, data: .bool(value.data.as_bool));
    case BPX_SD_VALUE_TYPE_UINT8:
        return SdValue(name: name, data: .u8(value.data.as_u8));
    case BPX_SD_VALUE_TYPE_UINT16:
        return SdValue(name: name, data: .u16(value.data.as_u16));
    case BPX_SD_VALUE_TYPE_UINT32:
        return SdValue(name: name, data: .u32(value.data.as_u32));
    case BPX_SD_VALUE_TYPE_UINT64:
        return SdValue(name: name, data: .u64(value.data.as_u64));
    case BPX_SD_VALUE_TYPE_INT8:
        return SdValue(name: name, data: .i8(value.data.as_i8));
    case BPX_SD_VALUE_TYPE_INT16:
        return SdValue(name: name, data: .i16(value.data.as_i16));
    case BPX_SD_VALUE_TYPE_INT32:
        return SdValue(name: name, data: .i32(value.data.as_i32));
    case BPX_SD_VALUE_TYPE_INT64:
        return SdValue(name: name, data: .i64(value.data.as_i64));
    case BPX_SD_VALUE_TYPE_FLOAT:
        return SdValue(name: name, data: .f32(value.data.as_float));
    case BPX_SD_VALUE_TYPE_DOUBLE:
        return SdValue(name: name, data: .f64(value.data.as_double));
    case BPX_SD_VALUE_TYPE_STRING:
        let str = String(utf8String: value.data.as_string)!;
        return SdValue(name: name, data: .string(str));
    case BPX_SD_VALUE_TYPE_ARRAY:
        let arr = value.data.as_array;
        let len = bpx_sd_array_len(arr);
        var data: [bpx_sd_value_t] = [bpx_sd_value_t](repeating: bpx_sd_value_t(), count: len);
        data.withUnsafeMutableBufferPointer { ptr in
            bpx_sd_array_list(arr, ptr.baseAddress);
        };
        var varr: [SdValue] = [];
        for value in data {
            if let decoded = decodeValue(name: nil, value: value) {
                varr.append(decoded);
            }
        }
        return SdValue(name: name, children: varr, isArray: true);
    case BPX_SD_VALUE_TYPE_OBJECT:
        let obj = value.data.as_object;
        let debug = bpx_sd_object_get(obj, "__debug__");
        if debug.type == BPX_SD_VALUE_TYPE_ARRAY {
            return decodeDebuggableObject(name: name, arr: debug.data.as_array, obj: obj);
        } else {
            return decodeUndebuggableObject(name: name, obj: obj);
        }
    default:
        return nil;
    }
}

fileprivate func decodeDebuggableObject(name: SdValue.Name?, arr: bpx_sd_array_t?, obj: bpx_sd_object_t?) -> SdValue {
    var data: [bpx_sd_value_t] = [bpx_sd_value_t](repeating: bpx_sd_value_t(), count: bpx_sd_array_len(arr));
    data.withUnsafeMutableBufferPointer { ptr in
        bpx_sd_array_list(arr, ptr.baseAddress);
    };
    var names: [bpx_u64_t: String] = [:];
    for value in data {
        if value.type == BPX_SD_VALUE_TYPE_STRING {
            let hash = bpx_hash(value.data.as_string);
            let name = String(utf8String: value.data.as_string)!;
            names[hash] = name;
        }
    }
    var varr: [SdValue] = [];
    var entries: [bpx_sd_object_entry_t] = [bpx_sd_object_entry_t](repeating: bpx_sd_object_entry_t(), count: bpx_sd_object_len(obj));
    entries.withUnsafeMutableBufferPointer { ptr in
        bpx_sd_object_list(obj, ptr.baseAddress);
    };
    for entry in entries {
        if let decoded = decodeValue(name: SdValue.Name(hash: entry.hash, name: names[entry.hash]), value: entry.value) {
            varr.append(decoded);
        }
    }
    return SdValue(name: name, children: varr);
}

fileprivate func decodeUndebuggableObject(name: SdValue.Name?, obj: bpx_sd_object_t?) -> SdValue {
    let len = bpx_sd_object_len(obj);
    var data: [bpx_sd_object_entry_t] = [bpx_sd_object_entry_t](repeating: bpx_sd_object_entry_t(), count: len);
    data.withUnsafeMutableBufferPointer { ptr in
        bpx_sd_object_list(obj, ptr.baseAddress);
    };
    var varr: [SdValue] = [];
    for entry in data {
        if let decoded = decodeValue(name: SdValue.Name(hash: entry.hash), value: entry.value) {
            varr.append(decoded);
        }
    }
    return SdValue(name: name, children: varr);
}

extension SectionData {
    func loadStructuredData() throws -> SdValue {
        var value = bpx_sd_value_t();
        let err = bpx_sd_value_decode_section(inner, &value);
        if err != BPX_ERR_NONE {
            throw SdError.fromc(code: err)!;
        }
        let decoded = decodeValue(name: nil, value: value);
        bpx_sd_value_free(&value);
        return decoded!;
    }
}
