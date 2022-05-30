//
//  SelectableItem.swift
//  BPXViewer
//
//  Created by Yuri Edwrad on 5/26/22.
//

import SwiftUI

struct SelectableItem<C: View, K: Equatable>: View {
    let content: () -> C;

    @Binding var selected: K;
    var key: K;

    init(key: K, selected: Binding<K>, @ViewBuilder content: @escaping () -> C) {
        self.content = content;
        self.key = key;
        self._selected = selected;
    }

    var body: some View {
        if selected == key {
            VStack(content: content)
                .padding()
                .frame(maxWidth: .infinity)
                .overlay(RoundedRectangle(cornerRadius: 12)
                            .inset(by: 4)
                            .stroke(lineWidth: 4)
                            .foregroundColor(.accentColor))
        } else {
            VStack(content: content)
                .padding()
                .frame(maxWidth: .infinity)
                .overlay(RoundedRectangle(cornerRadius: 12)
                            .inset(by: 4)
                            .stroke(lineWidth: 4)
                            .foregroundColor(.primary))
                .onTapGesture {
                    selected = key
                }
        }
    }
}

struct SelectableItem_Previews: PreviewProvider {
    static var previews: some View {
        SelectableItem(key: 1, selected: .constant(1)) {
            Text("test")
        }
    }
}
