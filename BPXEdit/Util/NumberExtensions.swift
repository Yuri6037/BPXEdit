//
//  NumberExtensions.swift
//  BPXViewer
//
//  Created by Yuri Edwrad on 7/15/22.
//

import Foundation

protocol Validate {
    static func validate(value: String) -> String;
}

protocol Integer: BinaryInteger {
    static var min: Self { get };
    static var max: Self { get };
}

extension Int8: Integer {}

extension UInt8: Integer {}

extension Int16: Integer {}

extension UInt16: Integer {}

extension Int32: Integer {}

extension UInt32: Integer {}

extension Int64: Integer {}

extension UInt64: Integer {}

extension Float32: Validate {
    static func validate(value: String) -> String {
        let filtered = value.filteredFloat;
        if filtered != value {
            return filtered;
        }
        let numeric = Float32(filtered);
        if numeric == nil {
            return "0.0";
        }
        return value;
    }
}

extension Float64: Validate {
    static func validate(value: String) -> String {
        let filtered = value.filteredFloat;
        if filtered != value {
            return filtered;
        }
        let numeric = Float64(filtered);
        if numeric == nil {
            return "0.0";
        }
        return value;
    }
}

protocol Number {
    associatedtype Context = ();
    func increment() -> Self;
    func decrement() -> Self;
    static func toNumber(context: Context, string: String) -> Self;
    static func validate(context: Context, value: String) -> String;
    func toString() -> String;
}

extension Number where Self: Integer {
    func increment() -> Self {
        if self == Self.max {
            return self;
        } else {
            return self + 1;
        }
    }

    func decrement() -> Self {
        if self == Self.min {
            return self;
        } else {
            return self - 1;
        }
    }

    func toString() -> String {
        String(self)
    }
}

extension Number where Self: LosslessStringConvertible {
    static func toNumber(context: Self.Context, string: String) -> Self {
        Self(validate(context: context, value: string))!
    }
}

extension Number where Self: LosslessStringConvertible & Integer {
    static func validate(context: Self.Context, value: String) -> String {
        let filtered = value.filteredInt;
        let numeric = Int64(filtered)!;
        let newNumeric: Int64;
        if numeric > max {
            newNumeric = Int64(max);
        } else if numeric < min {
            newNumeric = Int64(min);
        } else {
            newNumeric = numeric;
        }
        if numeric != newNumeric {
            let str = String(newNumeric);
            return str.filteredInt;
        } else if value != filtered {
            return filtered;
        }
        return value;
    }
}

extension Int8: Number {}

extension UInt8: Number {}

extension Int16: Number {}

extension UInt16: Number {}

extension Int32: Number {}

extension UInt32: Number {}

extension Int64: Number {
    static func validate(context: (), value: String) -> String {
        let filtered = value.filteredInt;
        let numeric = Int64(filtered);
        if numeric == nil {
            if filtered.first! == "-" {
                return Int64.min.toString();
            } else {
                return Int64.max.toString();
            }
        } else if filtered != value {
            return filtered;
        }
        return value;
    }
}

extension UInt64: Number {
    static func validate(context: (), value: String) -> String {
        let filtered = value.filter { v in v.isNumeric };
        let numeric = UInt64(filtered);
        if numeric == nil {
            return UInt64.max.toString();
        } else if filtered != value {
            return filtered;
        }
        return value;
    }
}

extension Float32: Number {
    func increment() -> Float32 {
        self + 1
    }

    func decrement() -> Float32 {
        self - 1
    }

    static func validate(context: (), value: String) -> String {
        Self.validate(value: value)
    }

    func toString() -> String {
        self.formatted()
    }
}

extension Float64: Number {
    func increment() -> Float64 {
        self + 1
    }

    func decrement() -> Float64 {
        self - 1
    }

    static func validate(context: (), value: String) -> String {
        Self.validate(value: value)
    }

    func toString() -> String {
        self.formatted()
    }
}
