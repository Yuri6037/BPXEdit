//
//  ErrorView.swift
//  BPXViewer
//
//  Created by Yuri Edwrad on 6/3/22.
//

import Foundation
import SwiftUI

struct ErrorInfo: LocalizedError {
    let title: String;
    let message: String;

    var errorDescription: String? {
        return title;
    }

    init(title: String = "BPX Error", message: String) {
        self.title = title;
        self.message = message;
    }
}

class ErrorHost: ObservableObject {
    @Published var current: ErrorInfo = ErrorInfo(message: "Null");
    @Published var showErrorAlert = false;
    var queue: [ErrorInfo] = [];

    func spawn(_ error: ErrorInfo) {
        queue.append(error);
        if !showErrorAlert {
            if let error = queue.popLast() {
                current = error;
                showErrorAlert = true;
            }
        }
    }

    func close() {
        if showErrorAlert {
            if let error = queue.popLast() {
                current = error;
            } else {
                showErrorAlert = false;
            }
        }
    }
}

fileprivate struct ErrorHandlerViewModifier: ViewModifier {
    @EnvironmentObject var errorHost: ErrorHost;

    func body(content: Content) -> some View {
        content.alert(isPresented: $errorHost.showErrorAlert, error: errorHost.current, actions: { _ in
            Button("OK") {
                errorHost.close()
            }
        }) { error in
            Text(error.message)
        }
    }
}

fileprivate struct ErrorhandlerView<C: View>: View {
    @State var env = ErrorHost();
    let content: C;

    var body: some View {
        VStack {
            content.modifier(ErrorHandlerViewModifier())
        }
        .environmentObject(env)
    }
}

extension View {
    func withErrorHandler() -> some View {
        ErrorhandlerView(content: self)
    }
}
