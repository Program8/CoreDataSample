//
//  ContentView.swift
//  CoreDataSample
//
//  Created by Vijay Sachan on 09/03/25.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var cdm = CDManager.shared
    @State private var isNavigating = false  // State to control navigation
    
    var body: some View {
        NavigationStack {
            ScrollView{
                VStack(alignment: .leading,spacing:10){
                    Section(header: Text("Note 1").font(.headline)) {
                        Text("Current MigrationType = \(cdm.currentMigrationType.rawValue)").font(.title3)
                    }
                    Section(header: Text("Note 2").font(.headline)) {
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
                    }
                }
            }.navigationTitle("Core Data")
                .navigationDestination(isPresented: $isNavigating) {
                    ViewActionList()  // Destination View
                }
        }.padding(10)
    }
}
#Preview {
    ContentView().environmentObject(AlertManager.shared)
}
