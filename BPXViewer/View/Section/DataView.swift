//
//  DecodedView.swift
//  BPXViewer
//
//  Created by Yuri Edwrad on 5/27/22.
//

import SwiftUI

struct StructView: View {
    let value: [String: Value];
    @Binding var container: Container?;

    var body: some View {
        VStack {
            ForEach(value.sorted(by: { $0.0 < $1.0 }), id: \.key) { key, value in
                HStack {
                    Text(key + ": ")
                    Spacer()
                    ValueView(value: value, container: $container)
                }
            }
        }
    }
}

struct ArrayView: View {
    let value: [Value];
    @Binding var container: Container?;

    var body: some View {
        List {
            ForEach(0..<value.count) { id in
                ValueView(value: value[id], container: $container)
                    .blockView()
                    .frame(maxWidth: .infinity)
            }
        }
        .frame(minHeight: 200)
    }
}

struct ValueView: View {
    let value: Value;
    @Binding var container: Container?;

    var body: some View {
        switch value {
        case .scalar(let scalar):
            Text(scalar.toString()).textSelection(.enabled)
        case .structure(let dictionary):
            StructView(value: dictionary, container: $container)
        case .array(let array):
            ArrayView(value: array, container: $container)
        case .pointer(let ptr):
            PointerView(pointer: ptr, container: container)
        }
    }
}

struct DataView: View {
    @Binding var value: Value;
    @Binding var container: Container?;

    var body: some View {
        ValueView(value: value, container: $container)
    }
}

struct DataView_Previews: PreviewProvider {
    static var previews: some View {
        DataView(value: .constant(
            .array([
                .structure([
                    "Field1": .scalar(.u8(42)),
                    "Field2": .scalar(.bool(false))
                ])
            ])
        ), container: .constant(nil))
    }
}
