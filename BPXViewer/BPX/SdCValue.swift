//
//  SdCValue.swift
//  BPXViewer
//
//  Created by Yuri Edwrad on 7/18/22.
//

import Foundation

class SdCValue {
    private var value: bpx_sd_value_t;

    init(fromc value: bpx_sd_value_t) {
        self.value = value;
    }

    init(from value: SdValue) {
        if let children = value.children {
            if value.isArray {
                self.value = bpx_sd_value_new_array();
            } else {
                self.value = bpx_sd_value_new_object();
            }
            for v in children {
                let _ = append(v)
            }
        } else {
            if let data = value.data {
                switch data {
                case .u8(let v):
                    self.value = bpx_sd_value_new_u8(v);
                case .u16(let v):
                    self.value = bpx_sd_value_new_u16(v);
                case .u32(let v):
                    self.value = bpx_sd_value_new_u32(v);
                case .u64(let v):
                    self.value = bpx_sd_value_new_u64(v);
                case .i8(let v):
                    self.value = bpx_sd_value_new_i8(v);
                case .i16(let v):
                    self.value = bpx_sd_value_new_i16(v);
                case .i32(let v):
                    self.value = bpx_sd_value_new_i32(v);
                case .i64(let v):
                    self.value = bpx_sd_value_new_i64(v);
                case .bool(let v):
                    self.value = bpx_sd_value_new_bool(v);
                case .f32(let v):
                    self.value = bpx_sd_value_new_float(v);
                case .f64(let v):
                    self.value = bpx_sd_value_new_double(v);
                case .string(let v):
                    self.value = v.withCString({ cstr in bpx_sd_value_new_string(v) });
                }
            } else {
                self.value = bpx_sd_value_new();
            }
        }
    }

    init() {
        value = bpx_sd_value_new_object();
    }

    func write(section: SectionData) {
        bpx_sd_value_encode(section.inner, &value);
    }

    func append(_ item: SdValue) -> Bool {
        let val = SdCValue(from: item);
        if value.type == BPX_SD_VALUE_TYPE_ARRAY {
            bpx_sd_array_push(value.data.as_array, &val.value);
            return true;
        } else if value.type == BPX_SD_VALUE_TYPE_OBJECT {
            guard let name = item.name else { return false; }
            guard let name = name.name else { return false; }
            name.withCString({ cstr in bpx_sd_object_set(value.data.as_object, cstr, &val.value) });
            return true;
        }
        return false;
    }

    deinit {
        bpx_sd_value_free(&value);
    }
}
