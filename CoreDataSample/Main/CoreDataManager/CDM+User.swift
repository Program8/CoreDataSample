//
//  CDM+User.swift
//  CoreDataSample
//
//  Created by Vijay Sachan on 09/03/25.
//

import Foundation
import CoreData

extension User{
    static func saveUser(){
        let bgContext = CDM.shared.newBgContext
        bgContext.perform {
            // Simulate a delay (e.g., network latency)
                    sleep(5) // Blocking delay (5 seconds)

            let user = User(context: bgContext)
            user.id = UUID()
            user.name = "Test"
            user.createdAt = Date()
            user.email = "test@gmail.com"
            do {
                try bgContext.save()
                print("User saved successfully")
            } catch {
                print("Failed to save user: \(error.localizedDescription)")
            }
        }
    }
    // Fetch all Users
    static func fetchUsers() -> [User] {
        let bgContext = CDM.shared.viewContext
            let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)] // Latest users first
            
            do {
                return try bgContext.fetch(fetchRequest)
            } catch {
                print("Failed to fetch users: \(error.localizedDescription)")
                return []
            }
        }
}
