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
        return filtered.isEmpty ? "0" : filtered
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
        return filtered.isEmpty ? "0" : filtered
    }
}
