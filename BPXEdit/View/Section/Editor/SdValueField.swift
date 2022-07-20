//
//  SdValueField.swift
//  BPXViewer
//
//  Created by Yuri Edwrad on 7/10/22.
//

import SwiftUI

struct SdValueField: View {
    @State var name = "";
    @StateObject var value = SdValueModel();
    let withName: Bool;
    let insertAction: (SdValue) -> Void;

    func getValue() -> SdValue {
        SdValue(
            name: withName ? SdValue.Name(name: name) : nil,
            data: value.valueData,
            children: value.dataType.hasChildren() ? [] : nil,
            isArray: value.dataType == .array
        )
    }

    var body: some View {
        VStack {
            if withName {
                TextField("Name", text: $name)
            }
            Picker("Type", selection: $value.dataType) {
                ForEach(SdDataType.allCases) { elem in
                    Text(elem.rawValue).tag(elem)
                }
            }
            if !value.dataType.hasChildren() {
                if let num = value.dataType.getNumberType() {
                    NumberInput(value: $value.number, context: num)
                } else {
                    if value.dataType == .bool {
                        Picker("Value", selection: $value.bool) {
                            Text("True").tag(true)
                            Text("False").tag(false)
                        }
                    } else {
                        TextField("Value", text: $value.string)
                    }
                }
            }
            Button(action: { insertAction(getValue()) }) {
                Image(systemName: "plus")
            }
            .help("Insert item")
        }
    }
}

struct SdValueField_Previews: PreviewProvider {
    static var previews: some View {
        SdValueField(withName: true, insertAction: { _ in })
    }
}
