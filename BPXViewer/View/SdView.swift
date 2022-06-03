//
//  SdView.swift
//  BPXViewer
//
//  Created by Yuri Edwrad on 5/31/22.
//

import SwiftUI

struct SdView: View {
    @Binding var value: SdValue;
    let indentation: CGFloat;
    let step: CGFloat;

    init(value: Binding<SdValue>, indentation: CGFloat = 0, step: CGFloat = 24) {
        _value = value;
        self.indentation = indentation;
        self.step = step;
    }

    func getIconName() -> String {
        if value.isArray {
            return "list.bullet"
        } else if (!value.isArray && value.children != nil) {
            return "tray.2";
        } else {
            return "doc.richtext"
        }
    }

    var body: some View {
        if value.children != nil {
            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: getIconName())
                    Text(value.description())
                        .textSelection(.enabled)
                }
                .padding(.leading, indentation)
                VStack(alignment: .leading) {
                    ForEach(value.children!) { value in
                        SdView(value: .constant(value), indentation: indentation + step, step: step)
                    }
                }
            }
        } else {
            HStack {
                Image(systemName: getIconName())
                Text(value.description())
                    .textSelection(.enabled)
            }
            .padding(.leading, indentation)
        }
    }
}

struct SdView_Previews: PreviewProvider {
    static var previews: some View {
        SdView(value: .constant(SdValue(
            name: SdValue.Name(hash: 0, name: "Test"),
            children: [
                SdValue(name: SdValue.Name(hash: 0, name: "Test1"), data: .u8(42)),
                SdValue(name: SdValue.Name(hash: 0, name: "Test2"), children: [
                    SdValue(name: SdValue.Name(hash: 0, name: "Test3"), data: .u8(42)),
                    SdValue(name: SdValue.Name(hash: 0, name: "Test4"), data: .u8(42))
                ])
            ]
        )))
    }
}
