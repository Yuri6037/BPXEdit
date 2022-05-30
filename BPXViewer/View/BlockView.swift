//
//  BlockView.swift
//  BPXViewer
//
//  Created by Yuri Edwrad on 5/29/22.
//

import SwiftUI

struct BlockViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        content.padding()
            .background(Color("MainHeader"))
            .cornerRadius(12)
            .shadow(radius: 8)
            .padding()
    }
}

extension View {
    func blockView() -> some View {
        modifier(BlockViewModifier())
    }
}
