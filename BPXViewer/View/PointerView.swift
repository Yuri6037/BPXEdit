//
//  PointerView.swift
//  BPXViewer
//
//  Created by Yuri Edwrad on 6/2/22.
//

import SwiftUI

struct PointerView<C: View>: View {
    let address: Pointer.Address;
    let content: () -> C;
    @State var showPopover = false;

    init(address: Pointer.Address, @ViewBuilder content: @escaping () -> C) {
        self.address = address;
        self.content = content;
    }

    var body: some View {
        Button(action: { showPopover = !showPopover }) {
            Text(self.address.toString())
        }
        .popover(isPresented: $showPopover, content: content)
    }
}

struct PointerView_Previews: PreviewProvider {
    static var previews: some View {
        PointerView(address: .p8(42)) {
            Text("This is a test")
        }
    }
}
