//
//  StringExtensions.swift
//  BPXViewer
//
//  Created by Yuri Edwrad on 7/15/22.
//

import Foundation

extension String {
    var filteredInt: String {
        var canBeNegative = true;
        let filtered = filter { v in
            if v == "-" && canBeNegative {
                canBeNegative = false;
                return true;
            }
            canBeNegative = false;
            return v.isNumeric;
        };
        if filtered.isEmpty {
            return "0";
        } else if filtered == "-" {
            return "-0";
        } else {
            return filtered;
        }
    }

    var filteredFloat: String {
        var canBeNegative = true;
        var decimal = false;
        let filtered = filter { v in
            if v == "-" && canBeNegative {
                canBeNegative = false;
                return true;
            }
            if v == "." && !decimal {
                decimal = true;
                return true;
            }
            canBeNegative = false;
            return v.isNumeric;
        };
        if filtered.isEmpty {
            return "0";
        } else if filtered == "-" {
            return "-0";
        } else if filtered.last == "." {
            return filtered + "0";
        } else {
            return filtered;
        }
    }

    func equivalent(_ other: String) -> Bool {
        if other == "-0" && (self == "-" || self == "-0" || self == "0") {
            return true;
        }
        if other.count >= 2 {
            let whatever = other + "x"; //Needed otherwise Swift crashes; go figure why the fuck Swift is partially 1 indexed!
            let part1 = whatever.slice(other.count - 2, other.count);
            if part1 == ".0x" {
                return self == other.slice(0, other.count - 3);
            }
        }
        return self == other;
    }
}
