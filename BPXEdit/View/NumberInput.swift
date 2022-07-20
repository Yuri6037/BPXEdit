//
//  NumberInput.swift
//  BPXViewer
//
//  Created by Yuri Edwrad on 7/14/22.
//

import SwiftUI

struct NumberInput<T: Number>: View {
    @Binding var value: T;
    let context: T.Context;

    //Hack start
    // reason: SwiftUI TextField implementation refuses to detect that it got
    // out of sync with the actual value it should show so use a hacky buffer
    // which is set to the updated value when the buffer no longer matches the current value.
    @State var buffer = "";
    private var text: Binding<String> {
        Binding<String>(get: {
            if value.toString() != buffer {
                DispatchQueue.main.async {
                    buffer = value.toString();
                }
            }
            return buffer;
        }, set: { text in
            value = T.toNumber(context: context, string: text);
            buffer = text;
        })
    }
    //Hack end

    var body: some View {
        HStack(spacing: 0) {
            TextField("Value", text: text)
            VStack(spacing: 0) {
                Button(action: { value.increment() }) {
                    Image(systemName: "plus")
                }
                Button(action: { value.decrement() }) {
                    Image(systemName: "minus")
                }
            }
        }
    }
}

struct NumberInput_Previews: PreviewProvider {
    static var previews: some View {
        NumberInput(value: .constant(UInt8(0)), context: ())
    }
}
