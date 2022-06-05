//
//  Loader.swift
//  BPXViewer
//
//  Created by Yuri Edwrad on 5/29/22.
//

import Foundation
import TOMLDecoder

fileprivate func tomlLoad<T: Codable>(path: String) throws -> T {
    let string = try String(contentsOfFile: path, encoding: String.Encoding.utf8);
    let obj = try TOMLDecoder().decode(T.self, from: string);
    return obj;
}

func loadBundle(path: String, id: UUID = UUID(), date: Date = Date.now) throws -> Bundle {
    let mainFile = path + "/main.toml";
    let main = try tomlLoad(path: mainFile) as BundleMain; //Oh my... Not even able to directly instantiate a generic function! WTF!? Even rust can do this!!
    var typeDescs: [Int: TypeDesc] = [:]
    if let filename =  main.decoder {
        typeDescs[-1] = try tomlLoad(path: path + "/" + filename);
    }
    for section in main.section {
        if let filename = section.decoder {
            typeDescs[Int(section.code)] = try tomlLoad(path: path + "/" + filename);
        }
    }
    return Bundle(id: id, date: date, main: main, typeDescs: typeDescs);
}
