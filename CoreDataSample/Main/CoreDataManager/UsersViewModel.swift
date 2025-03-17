//
//  UsersViewModel.swift
//  CoreDataSample
//
//  Created by Vijay Sachan on 14/03/25.
//
import CoreData
class UsersViewModel: NSObject, ObservableObject, NSFetchedResultsControllerDelegate {
    private let delayForSeconds:UInt32? = 3//nil
    private let fetchedResultsController: NSFetchedResultsController<User>
    @Published var users: [User] = []
    @Published var showLoader=false
    @Published var totalUsers:Int = 0
    @Published var totalUsersDataInMemory:Int = 0
    override init() {
        let request: NSFetchRequest<User> = User.fetchRequest()
        request.fetchBatchSize=25
        request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: CDM.shared.newBgContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        super.init()
        fetchedResultsController.delegate = self
    }
    func fetchUsers(){
        showLoader=true
        fetchedResultsController.managedObjectContext.perform{[self] in
            if let val=self.delayForSeconds{sleep(val)}
            do {
                try fetchedResultsController.performFetch()
                let usersBgThread = fetchedResultsController.fetchedObjects ?? []
                let objectIDs = usersBgThread.map { $0.objectID }
                let mainContext = CDM.shared.viewContext
                mainContext.performAndWait{
                    let usersInMainContext = objectIDs.compactMap { objectID in
                        mainContext.object(with: objectID) as? User
                    }
                    self.users=usersInMainContext
                }
            } catch {
                print("Error fetching users: \(error)")
                AlertManager.shared.show(title: "Fetch Error", message: error.localizedDescription)
                invokeInUIThread(self.users=[])
            }
            invokeInUIThread {
                self.totalUsers=self.users.count;
                self.countNoFaultObjects()
                self.showLoader=false
            }
        }
    }
    //     func fetchUsers() {
    //            let bgContext = CDM.shared.newBgContext
    //            let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
    //            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)] // Latest users first
    //            bgContext.perform{
    //                do {
    //                    let users=try bgContext.fetch(fetchRequest)
    //                    let objectIDs = users.map { $0.objectID }
    //                    let mainContext = CDM.shared.viewContext
    //                    mainContext.perform {
    //                        // Transfer objects to main context
    //
    //                        let usersInMainContext = objectIDs.compactMap { objectID in
    //                            mainContext.object(with: objectID) as? User
    //                        }
    //                        self.users=usersInMainContext
    //                    }
    //    //                DispatchQueue.main.async{closure(.failure(MyError.SomeError))}
    //                } catch {
    //                    print("Failed to fetch users: \(error.localizedDescription)")
    //
    //                }
    //            }
    //        }
    func countNoFaultObjects(){
        totalUsersDataInMemory=users.filter({!$0.isFault}).count
        print("Data loaded for = \(totalUsersDataInMemory) objects")
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        DispatchQueue.main.async {
            self.users = self.fetchedResultsController.fetchedObjects ?? []
            //            Utility.log(msg: "users count = \(self.users.count)")
            print("users count = \(self.users.count)")
        }
    }
}
// MARK: Save
extension UsersViewModel{
    func saveUser(noOfEntriesToSave:Int,name:String,email:String,onComplete:@escaping()->()){
        showLoader=true
        let bgContext = CDM.shared.newBgContext
        bgContext.perform {
            // Simulate a delay (e.g., network latency)
            if let val=self.delayForSeconds{sleep(val)}
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
                invokeInUIThread(onComplete())
            } catch {
                print("Failed to save user: \(error.localizedDescription)")
                AlertManager.shared.show(title: "Save Error", message: error.localizedDescription)
            }
            invokeInUIThread(self.showLoader=false)
        }
    }
}
