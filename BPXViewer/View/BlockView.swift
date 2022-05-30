//
//  BlockView.swift
//  BPXViewer
//
//  Created by Yuri Edwrad on 5/29/22.
//

import SwiftUI

struct BlockView<C: View>: View {
    let content: () -> C;

    init(@ViewBuilder content: @escaping () -> C) {
        self.content = content;
    }

    var body: some View {
        VStack(content: content)
            .padding()
            .background(Color("MainHeader"))
            .cornerRadius(12)
            .padding()
    }
}

struct BlockView_Previews: PreviewProvider {
    static var previews: some View {
        BlockView {
            Text("test")
        }
    }
}
