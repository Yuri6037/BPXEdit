//
//  DecodedView.swift
//  BPXViewer
//
//  Created by Yuri Edwrad on 5/27/22.
//

import SwiftUI

struct StructView: View {
    let value: [String: Value];

    var body: some View {
        VStack {
            ForEach(value.sorted(by: { $0.0 < $1.0 }), id: \.key) { key, value in
                HStack {
                    Text(key)
                    Spacer()
                    ValueView(value: value)
                }
            }
        }
    }
}

struct ArrayView: View {
    let value: [Value];

    var body: some View {
        List {
            ForEach(0..<value.count) { id in
                ValueView(value: value[id])
                    .padding()
                    .frame(maxWidth: .infinity)
                    .overlay(RoundedRectangle(cornerRadius: 12)
                                .inset(by: 4)
                                .stroke(lineWidth: 4)
                                .foregroundColor(.primary))
            }
        }
    }
}

struct ValueView: View {
    let value: Value;

    var body: some View {
        switch value {
        case .scalar(let scalar):
            Text(scalar.toString())
        case .structure(let dictionary):
            StructView(value: dictionary)
        case .array(let array):
            ArrayView(value: array)
        }
    }
}

struct DecodedView: View {
    @Binding var value: Value?;

    var body: some View {
        ValueView(value: value!)
    }
}

struct DecodedView_Previews: PreviewProvider {
    static var previews: some View {
        DecodedView(value: .constant(
            .array([
                .structure([
                    "Field1": .scalar(.u8(42)),
                    "Field2": .scalar(.bool(false))
                ])
            ])
        ))
    }
}
