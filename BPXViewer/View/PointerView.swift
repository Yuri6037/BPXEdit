//
//  PointerView.swift
//  BPXViewer
//
//  Created by Yuri Edwrad on 6/2/22.
//

import SwiftUI

fileprivate struct HackBrokenViewBuilder: View {
    @Binding var value: Pointer.Value?;

    var body: some View {
        if let val = value {
            switch val {
            case .bpxsd(let v):
                SdView(value: .constant(v))
            case .string(let v):
                Text(v)
            }
        } else {
            Text("Loading...")
        }
    }
}

fileprivate struct HackBrokenState: View {
    @Binding var error: String?;
    @Binding var value: Pointer.Value?;

    var body: some View {
        if let err = error {
            Text(err)
        } else {
            HackBrokenViewBuilder(value: $value)
        }
    }
}

struct PointerView: View {
    let pointer: Pointer;
    let container: Container?;
    @State var error: String?;
    @State var value: Pointer.Value?;

    func tryLoadValue(flag: Bool) {
        if !flag || container == nil {
            return
        }
        do {
            let val = try pointer.load(container: container!);
            value = val;
        } catch {
            self.error = "Failed to load pointer: " + String(describing: error);
        }
    }

    var body: some View {
        PopoverButton(text: pointer.address.toString(), action: tryLoadValue) {
            HackBrokenState(error: $error, value: $value).padding()
        }
    }
}

struct PopoverButton<C: View>: View {
    let text: String;
    let content: () -> C;
    let action: (Bool) -> Void;
    @State var showPopover = false;

    init(text: String, action: @escaping (Bool) -> Void, @ViewBuilder content: @escaping () -> C) {
        self.text = text;
        self.content = content;
        self.action = action;
    }

    var body: some View {
        Button(action: { showPopover = !showPopover; action(showPopover); }) {
            Text(text)
        }
        .popover(isPresented: $showPopover, content: content)
    }
}

struct PointerView_Previews: PreviewProvider {
    static var previews: some View {
        PopoverButton(text: "42", action: {_ in }) {
            Text("This is a test")
        }
    }
}
