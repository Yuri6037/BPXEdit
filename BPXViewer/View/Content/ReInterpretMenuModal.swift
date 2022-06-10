//
//  ReInterpretMenuModal.swift
//  BPXViewer
//
//  Created by Yuri Edwrad on 6/10/22.
//

import SwiftUI

struct ReInterpretMenuModal: View {
    @Binding var isPresented: Bool;
    @State var selected: Int;
    fileprivate let bundles: [Bundle];
    let action: (Bundle?) -> Void;

    init(isPresented: Binding<Bool>, action: @escaping (Bundle?) -> Void, selected: Bundle? = nil) {
        _isPresented = isPresented;
        self.action = action;
        var hack = -1
        bundles = BundleManager.instance.getBundles();
        if let bundle = selected {
            for (i, v) in bundles.enumerated() {
                if v == bundle {
                    hack = i;
                    break;
                }
            }
        }
        _selected = State(initialValue: hack);
    }

    var body: some View {
        VStack {
            List {
                SelectableItem(key: -1, selected: $selected) {
                    Text("None").bold()
                }
                ForEach(Array(bundles.enumerated()), id: \.1) { index, bundle in
                    SelectableItem(key: index, selected: $selected) {
                        Text(bundle.main.name).bold()
                        Text(bundle.date.formatted())
                    }
                }
            }
            HStack {
                Button(action: { isPresented = false }) {
                    Text("Cancel")
                }
                .keyboardShortcut(.cancelAction)
                Spacer()
                Button(action: {
                    isPresented = false;
                    if selected >= 0 && selected < bundles.count {
                        self.action(bundles[selected]);
                    } else {
                        self.action(nil);
                    }
                }) {
                    Text("Re-interpret")
                }
                .keyboardShortcut(.defaultAction)
            }
        }.padding()
    }
}

struct ReInterpretMenuModal_Previews: PreviewProvider {
    static var previews: some View {
        ReInterpretMenuModal(isPresented: .constant(true), action: { bundle in print(bundle) })
    }
}
