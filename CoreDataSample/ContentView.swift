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
            
            Text("Core Data").font(.largeTitle).multilineTextAlignment(.center)
            ScrollView{
                VStack(spacing: 10) {
                    if let isLoaded = cdm.isLoaded {
                        if isLoaded {
                            Text("Core Data provides four store types—SQLite, Binary, XML, and In-Memory (the XML store is not available on iOS)").font(.title3)
                            Text(cdm.loadingMsg).font(.title3).multilineTextAlignment(.leading).foregroundStyle(.black)
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
                }
                    .navigationTitle("Home")
                    .navigationDestination(isPresented: $isNavigating) {
                        ViewCoreData()  // Destination View
                    }
            }
        }.padding(10)
    }
}
#Preview {
    ContentView().environmentObject(AlertManager.shared)
}
