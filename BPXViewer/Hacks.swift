//
//  Hacks.swift
//  BPXViewer
//
//  Created by Yuri Edwrad on 6/5/22.
//

import Foundation

//This file groups some hacks for Swift and SwiftUI to workarround some of their stupid design decisions...

//--> Hack required for swiftui garbage <--
//This basically forces swiftui to accept non-hashable/equatable types which are easily derived from the id because UUID is by definition UNIQUE!!!!
protocol BypassHashable: Hashable, Identifiable { }

extension BypassHashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}
//--> End <--

//This is required to support rendering string section. Unfortunatly this sometimes throws many errors in console because string sections are not guarenteed to be unique strings.
extension String: Identifiable {
    public typealias ID = Int
    public var id: Int {
        return hash
    }
}

//Well this is kind of BASIC functionality which is necessary for parsing...
extension StringProtocol {
    func slice(_ start: Int, _ end: Int) -> String {
        let lower = index(self.startIndex, offsetBy: start)
        let upper = index(lower, offsetBy: end - start)
        return String(self[lower...upper])
    }
}
