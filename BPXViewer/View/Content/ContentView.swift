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
