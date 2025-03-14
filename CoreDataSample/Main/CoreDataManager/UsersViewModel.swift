//
//  UsersViewModel.swift
//  CoreDataSample
//
//  Created by Vijay Sachan on 14/03/25.
//
import CoreData
class UsersViewModel: NSObject, ObservableObject, NSFetchedResultsControllerDelegate {
    private let fetchedResultsController: NSFetchedResultsController<User>
    @Published var users: [User] = []

    init(context: NSManagedObjectContext) {
        let request: NSFetchRequest<User> = User.fetchRequest()
        request.fetchBatchSize=25
        request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        super.init()
        fetchedResultsController.delegate = self
        
//        fetchUsers()
    }
    func fetchUsers() {
        do {
            try fetchedResultsController.performFetch()
            users = fetchedResultsController.fetchedObjects ?? []
            
//            print("users count = \(self.users.count)")
        } catch {
            print("Error fetching users: \(error)")
        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        DispatchQueue.main.async {
            self.users = self.fetchedResultsController.fetchedObjects ?? []
//            Utility.log(msg: "users count = \(self.users.count)")
            print("users count = \(self.users.count)")
        }
    }
}

