//
//  DecodedView.swift
//  BPXViewer
//
//  Created by Yuri Edwrad on 5/27/22.
//

import SwiftUI

@ViewBuilder func renderStruct(data: [String: Value]) -> some View {
    VStack {
        ForEach(data.sorted(by: { $0.0 < $1.0 }), id: \.key) { key, value in
            HStack {
                Text(key)
                Spacer()
                ValueView(value: value)
            }
        }
    }
}

@ViewBuilder func renderArray(data: [Value]) -> some View {
    List {
        ForEach(0..<data.count) { id in
            ValueView(value: data[id])
                .padding()
                .frame(maxWidth: .infinity)
                .overlay(RoundedRectangle(cornerRadius: 12)
                            .inset(by: 4)
                            .stroke(lineWidth: 4)
                            .foregroundColor(.primary))
        }
    }
}

@ViewBuilder func renderScalar(data: Value.Scalar) -> some View {
    Text(data.toString())
}

struct ValueView: View {
    let value: Value;

    var body: some View {
        switch value {
        case .scalar(let scalar):
            renderScalar(data: scalar)
        case .structure(let dictionary):
            renderStruct(data: dictionary)
        case .array(let array):
            renderArray(data: array)
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
