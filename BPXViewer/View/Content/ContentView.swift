//
//  ContentView.swift
//  BPXViewer
//
//  Created by Yuri Edwrad on 5/23/22.
//

import SwiftUI

struct ContentView: View {
    @Binding var document: BPXDocument
    @State var selected = -1;
    @StateObject var sectionState = SectionState();
    @EnvironmentObject var errorHost: ErrorHost;
    @State var bundle: Bundle?;
    @EnvironmentObject var globalState: GlobalState;
    @StateObject var windowState = WindowState();

    var body: some View {
        GeometryReader { geo in
            VStack {
                WindowReader { window in
                    if window != nil {
                        globalState.addWindow(window: window!, model: windowState);
                    }
                }
                .frame(width: 0, height: 0)
                HStack {
                    VStack {
                        MainView(document: $document, bundle: $bundle)
                            .environmentObject(sectionState)
                        NavigationView(document: $document, bundle: $bundle, selected: $selected)
                    }
                    //Main view
                    VStack {
                        ToolBarView(document: $document, bundle: $bundle, selected: $selected)
                            .environmentObject(sectionState)
                            .frame(maxWidth: .infinity)
                            .background(Color("MainHeader"))
                            .cornerRadius(6)
                        Spacer()
                        SectionView(document: $document)
                            .environmentObject(sectionState)
                    }
                    .frame(width: geo.size.width * 0.55)
                    .padding()
                }
            }
            .sheet(isPresented: $windowState.showReInterpretMenu) {
                ReInterpretMenuModal(
                    isPresented: $windowState.showReInterpretMenu,
                    action: { bundle in
                        self.bundle = bundle;
                        sectionState.reset();
                    },
                    selected: bundle
                ).frame(width: geo.size.width * 0.5, height: geo.size.height * 0.5)
            }
        }
        .onAppear {
            bundle = document.findBundle();
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(document: .constant(BPXDocument()))
    }
}