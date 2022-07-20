//
//  StringView.swift
//  BPXViewer
//
//  Created by Yuri Edwrad on 5/30/22.
//

import SwiftUI

struct StringView: View {
    @Binding var value: [String];

    var body: some View {
        List {
            ForEach(value) { text in
                Text(text)
            }
        }
    }
}

struct StringView_Previews: PreviewProvider {
    static var previews: some View {
        StringView(value: .constant(["Value 1", "Value 2"]))
    }
}
