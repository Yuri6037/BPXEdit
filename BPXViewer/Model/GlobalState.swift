//
//  GlobalState.swift
//  BPXViewer
//
//  Created by Yuri Edwrad on 6/8/22.
//

import Foundation
import AppKit

class WindowState: ObservableObject {
    @Published var showReInterpretMenu = false;
}

class GlobalState: NSObject, ObservableObject {
    @Published var windows = Set<NSWindow>();
    @Published var states: [Int: WindowState] = [:];
    @Published var activeState: WindowState?;
    @Published var activeWindow: NSWindow?;

    func addWindow(window: NSWindow, model: WindowState) {
        windows.insert(window);
        states[window.windowNumber] = model;
        window.delegate = self;
        //This is hack because somehow AppKit has a bug: the delegate is randomly not called when the window first becomes key.
        // This assumes every time a new window is spanwned it's forcely key.
        activeWindow = window;
        activeState = model;
    }
}

extension GlobalState: NSWindowDelegate {
    func windowWillClose(_ notification: Notification) {
        if let window = notification.object as? NSWindow {
            window.delegate = nil;
            windows.remove(window);
            states.removeValue(forKey: window.windowNumber);
            if activeWindow == window {
                activeWindow = nil;
                activeState = nil;
            }
        }
    }

    func windowDidBecomeKey(_ notification: Notification) {
        if let window = notification.object as? NSWindow {
            activeWindow = window;
            activeState = states[window.windowNumber];
        } else {
            activeWindow = nil;
            activeState = nil;
        }
    }
}
