//
//  BundleManagerView.swift
//  BPXViewer
//
//  Created by Yuri Edwrad on 6/3/22.
//

import SwiftUI
import UniformTypeIdentifiers;

struct BundleManagerView: View {
    @State var bundles: [Bundle] = BundleManager.instance.getBundles();
    @State var selected = 0;
    @State var window: NSWindow?;
    @EnvironmentObject var errorHost: ErrorHost;

    func installBundle() {
        let dialog = NSOpenPanel();
        dialog.title = "Choose a bundle to import.";
        dialog.showsResizeIndicator = true;
        dialog.showsHiddenFiles = false;
        dialog.canChooseDirectories = false;
        dialog.canCreateDirectories = false;
        dialog.allowsMultipleSelection = false;
        dialog.allowedContentTypes = [UTType(filenameExtension: "bundle", conformingTo: .package)!];
        dialog.beginSheetModal(for: window!) { response in
            if response == NSApplication.ModalResponse.OK {
                let bundle = BundleManager.instance.install(path: dialog.url!.path);
                if let bundle = bundle {
                    bundles.append(bundle);
                } else {
                    errorHost.spawn(BundleManager.instance.getLastError()!);
                }
            }
        }
    }

    func uninstallBundle() {
        if selected >= 0 && selected < bundles.count {
            let bundle = bundles[selected];
            BundleManager.instance.uninstall(bundle: bundle);
            if let err = BundleManager.instance.getLastError() {
                errorHost.spawn(err);
            } else {
                bundles.remove(at: selected);
            }
        }
    }

    var body: some View {
        VStack {
            WindowReader { window in
                self.window = window;
            }
            .frame(width: 0, height: 0)
            HStack {
                ToolButton(icon: "bag.badge.plus", text: "Add", action: installBundle)
                ToolButton(icon: "trash", text: "Remove", action: uninstallBundle)
            }
            List {
                ForEach(Array(bundles.enumerated()), id: \.1) { index, bundle in
                    SelectableItem(key: index, selected: $selected) {
                        Text(bundle.main.name).bold()
                        Text(bundle.date.formatted())
                    }
                }
            }
        }.onAppear {
            if let err = BundleManager.instance.getLastError() {
                errorHost.spawn(err);
            }
        }
    }
}

struct BundleManagerView_Previews: PreviewProvider {
    static var previews: some View {
        BundleManagerView()
    }
}

func openBundleManagerWindow() {
    let window = NSWindow(
        contentRect: NSRect(x: 0, y: 0, width: 800, height: 600),
        styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
        backing: .buffered,
        defer: true
    );
    window.title = "Type description bundles";
    let host = NSHostingController(rootView: AnyView(BundleManagerView().withErrorHandler()));
    window.contentViewController = host;
    window.isReleasedWhenClosed = false;
    window.makeKeyAndOrderFront(nil);
    //NSWindow is garbagely broken: contentRect is ignored no matter what you do. Additionally setFrame is always ignored when not called after `makeKeyAndOrderFront`...
    //Their exist no other order for this code line. Basically, YOU CANNOT set the size of the window before showing it...
    window.setFrame(NSRect(x: 0, y: 0, width: 480, height: 300), display: true);
    window.center();
}
