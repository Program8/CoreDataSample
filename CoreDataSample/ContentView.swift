//
//  ContentView.swift
//  CoreDataSample
//
//  Created by Vijay Sachan on 09/03/25.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var cdm = CDM.shared
    @State private var isNavigating = false  // State to control navigation

    var body: some View {
        NavigationStack {
            Text("Core Data Manager loading status").font(.largeTitle).multilineTextAlignment(.center)
            VStack {
                
                if let isLoaded = cdm.isLoaded {
                    if isLoaded {
                        Text(cdm.loadingMsg).font(.title3).multilineTextAlignment(.center).foregroundStyle(.green)
                        Button("Next") {
                            isNavigating = true
                        }.font(.title)
                        .padding()
                    }else{
                        Text(cdm.loadingMsg).font(.title3).multilineTextAlignment(.center).foregroundStyle(.red)
                    }
                } else {
                    Text("Please wait, loading core data model...")
                        .padding().font(.title)
                }
            }.padding(10)
            .navigationTitle("Home")
            .navigationDestination(isPresented: $isNavigating) {
                ViewCoreData()  // Destination View
            }
        }
    }
}
#Preview {
    ContentView()
}
