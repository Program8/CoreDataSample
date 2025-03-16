//
//  CoreDataSampleApp.swift
//  CoreDataSample
//
//  Created by Vijay Sachan on 09/03/25.
//

import SwiftUI

@main
struct CoreDataSampleApp: App {
    let coreDataManager = CDM.shared
    @StateObject var alertManager = AlertManager.shared
    var body: some Scene {
        WindowGroup {
            ContentView()
            .environmentObject(alertManager) // Inject globally
            .globalAlert()
        }
    }
}
