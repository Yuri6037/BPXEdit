//
//  DecodedView.swift
//  BPXViewer
//
//  Created by Yuri Edwrad on 5/27/22.
//

import SwiftUI

struct NestedArrayView: View {
    let value: [Value];
    @Binding var container: Container?;

    var body: some View {
        List {
            ForEach(0..<value.count) { id in
                ValueView(value: value[id], container: $container)
                    .frame(maxWidth: .infinity)
                if id != value.count - 1 {
                    Divider()
                }
            }
        }
        .blockView()
        .frame(minHeight: 200)
    }
}

struct StructView: View {
    let value: [String: Value];
    @Binding var container: Container?;

    var body: some View {
        VStack {
            ForEach(value.sorted(by: { $0.0 < $1.0 }), id: \.key) { key, value in
                if let array = value.asArray() {
                    HStack {
                        Text(key + ": ").bold()
                        Spacer()
                        NestedArrayView(value: array, container: $container)
                    }
                } else {
                    HStack {
                        Text(key + ": ").bold()
                        Spacer()
                        ValueView(value: value, container: $container)
                    }
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
                    //.padding(-8)
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
                    "Field2": .scalar(.bool(false)),
                    "Inner array": .array([
                        .structure([
                            "Field1": .scalar(.u8(42)),
                            "Field2": .scalar(.bool(false))
                        ])
                    ]),
                    "Inner struct": .structure([
                        "Field1": .scalar(.u8(42)),
                        "Field2": .scalar(.bool(false))
                    ])
                ])
            ])
        ), container: .constant(nil))
    }
}
