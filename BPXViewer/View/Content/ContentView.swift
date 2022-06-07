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

    func loadHex(_ index: Int) {
        sectionState.showHex(data: document.loadRaw(errorHost: errorHost, section: index));
    }

    func loadData(_ index: Int) {
        sectionState.showData(value: document.loadData(errorHost: errorHost, section: index, bundle: bundle!));
    }

    func loadStrings(_ index: Int) {
        sectionState.showStrings(value: document.loadStrings(errorHost: errorHost, section: index));
    }

    func loadStructuredData(_ index: Int) {
        sectionState.showStructuredData(value: document.loadStructuredData(errorHost: errorHost, section: index));
    }

    var body: some View {
        GeometryReader { geo in
            VStack {
                HStack {
                    VStack {
                        MainView(document: $document, bundle: $bundle)
                        NavigationView(document: $document, bundle: $bundle, selected: $selected)
                    }.environmentObject(sectionState)
                    //Main view
                    SectionView(document: $document)
                        .environmentObject(sectionState)
                        .frame(width: geo.size.width * 0.55)
                        .padding()
                }
            }
        }.onAppear {
            bundle = document.findBundle();
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(document: .constant(BPXDocument()))
    }
}
