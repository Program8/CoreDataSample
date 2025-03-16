//
//  CDM+User.swift
//  CoreDataSample
//
//  Created by Vijay Sachan on 09/03/25.
//
import Foundation
import CoreData

extension User{
    static let delay=false
    static let delayForSeconds:UInt32=1
    static func saveUser(noOfEntriesToSave:Int,name:String,email:String,closure:@escaping(Result<Bool,Error>)->()){
        let bgContext = CDM.shared.newBgContext
        bgContext.perform {
            // Simulate a delay (e.g., network latency)
            if User.delay{sleep(User.delayForSeconds)}
            for _ in 1...noOfEntriesToSave{
                let user = User(context: bgContext)
                user.id = UUID()
                user.name = name
                user.createdAt = Date()
                user.email = email
            }
            do {
                try bgContext.save()
                print("User saved successfully")
                DispatchQueue.main.async{closure(.success(true))}
            } catch {
                print("Failed to save user: \(error.localizedDescription)")
                DispatchQueue.main.async{closure(.failure(error))}
            }
        }
    }
    // Fetch all Users
    static func fetchUsers(_ closure:@escaping (Result<[User],Error>)->Void) {
        let bgContext = CDM.shared.newBgContext
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)] // Latest users first
        bgContext.perform{
            if User.delay{sleep(User.delayForSeconds)}
            do {
                let users=try bgContext.fetch(fetchRequest)
                // Transfer objects to main context
                            let mainContext = CDM.shared.viewContext
                            let mainThreadUsers = users.map { mainContext.object(with: $0.objectID) as! User }
                DispatchQueue.main.async{closure(.success(mainThreadUsers))}
//                DispatchQueue.main.async{closure(.failure(MyError.SomeError))}
            } catch {
                print("Failed to fetch users: \(error.localizedDescription)")
                DispatchQueue.main.async{closure(.failure(error))}
            }
        }
    }
}
enum MyError:Error{
    case SomeError(message:String)
}
