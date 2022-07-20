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

fileprivate protocol NumberInternal: Validate, BinaryInteger {
    static var min: Self { get };
    static var max: Self { get };

    init?(_ string: String);
}

extension NumberInternal {
    static func validate(value: String) -> String {
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
            let str = newNumeric.formatted();
            return str;
        } else if value != filtered {
            return filtered;
        }
        return value;
    }
}

extension Int8: NumberInternal {}

extension UInt8: NumberInternal {}

extension Int16: NumberInternal {}

extension UInt16: NumberInternal {}

extension Int32: NumberInternal {}

extension UInt32: NumberInternal {}

extension Int64: NumberInternal {
    static func validate(value: String) -> String {
        let filtered = value.filteredInt;
        if filtered != value {
            return filtered;
        }
        let numeric = Int64(filtered);
        if numeric == nil {
            return "0"
        }
        return value;
    }
}

extension UInt64: NumberInternal {
    static func validate(value: String) -> String {
        let filtered = value.filter { v in v.isNumeric };
        if filtered != value {
            return filtered;
        }
        let numeric = UInt64(filtered);
        if numeric == nil {
            return "0"
        }
        return value;
    }
}

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
    mutating func increment();
    mutating func decrement();
    static func toNumber(context: Context, string: String) -> Self;
    func toString() -> String;
}

extension Int8: Number {
    mutating func increment() {
        self += 1;
    }
    
    mutating func decrement() {
        self -= 1;
    }
    
    static func toNumber(context: (), string: String) -> Int8 {
        let v = Self.validate(value: string);
        return Self(v)!;
    }
    
    func toString() -> String {
        String(self)
    }
}

extension UInt8: Number {
    mutating func increment() {
        self += 1;
    }
    
    mutating func decrement() {
        self -= 1;
    }
    
    static func toNumber(context: (), string: String) -> UInt8 {
        let v = Self.validate(value: string);
        return Self(v)!;
    }
    
    func toString() -> String {
        String(self)
    }
}

extension Int16: Number {
    mutating func increment() {
        self += 1;
    }
    
    mutating func decrement() {
        self -= 1;
    }
    
    static func toNumber(context: (), string: String) -> Int16 {
        let v = Self.validate(value: string);
        return Self(v)!;
    }
    
    func toString() -> String {
        String(self)
    }
}

extension UInt16: Number {
    mutating func increment() {
        self += 1;
    }
    
    mutating func decrement() {
        self -= 1;
    }
    
    static func toNumber(context: (), string: String) -> UInt16 {
        let v = Self.validate(value: string);
        return Self(v)!;
    }
    
    func toString() -> String {
        String(self)
    }
}

extension Int32: Number {
    mutating func increment() {
        self += 1;
    }
    
    mutating func decrement() {
        self -= 1;
    }
    
    static func toNumber(context: (), string: String) -> Int32 {
        let v = Self.validate(value: string);
        return Self(v)!;
    }
    
    func toString() -> String {
        String(self)
    }
}

extension UInt32: Number {
    mutating func increment() {
        self += 1;
    }
    
    mutating func decrement() {
        self -= 1;
    }
    
    static func toNumber(context: (), string: String) -> UInt32 {
        let v = Self.validate(value: string);
        return Self(v)!;
    }
    
    func toString() -> String {
        String(self)
    }
}

extension Int64: Number {
    mutating func increment() {
        self += 1;
    }
    
    mutating func decrement() {
        self -= 1;
    }
    
    static func toNumber(context: (), string: String) -> Int64 {
        let v = Self.validate(value: string);
        return Self(v)!;
    }
    
    func toString() -> String {
        String(self)
    }
}

extension UInt64: Number {
    mutating func increment() {
        self += 1;
    }
    
    mutating func decrement() {
        self -= 1;
    }
    
    static func toNumber(context: (), string: String) -> UInt64 {
        let v = Self.validate(value: string);
        return Self(v)!;
    }
    
    func toString() -> String {
        String(self)
    }
}

extension Float32: Number {
    mutating func increment() {
        self += 1;
    }

    mutating func decrement() {
        self -= 1;
    }

    static func toNumber(context: (), string: String) -> Float32 {
        let v = Self.validate(value: string);
        return Self(v)!;
    }

    func toString() -> String {
        String(self)
    }
}

extension Float64: Number {
    mutating func increment() {
        self += 1;
    }

    mutating func decrement() {
        self -= 1;
    }

    static func toNumber(context: (), string: String) -> Float64 {
        let v = Self.validate(value: string);
        return Self(v)!;
    }

    func toString() -> String {
        String(self)
    }
}
