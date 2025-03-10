//
//  CoreDataManager.swift
//  CoreDataSample
//
//  Created by Vijay Sachan on 09/03/25.
//
import Foundation
import CoreData
/// Core Data Manager
class CDM:ObservableObject{
//    protocol Delegate:AnyObject{
//        func coreDataManager(isLoadPersistentStoresSuccess: Bool,errorMsg:String?)
//    }
    var viewContext: NSManagedObjectContext { persistentContainer.viewContext }
    var newBgContext:NSManagedObjectContext{persistentContainer.newBackgroundContext()}
//    var newBgContext:NSManagedObjectContext{viewContext}
    private let dataModelName:String="CoreDataModel"
    private var persistentContainer: NSPersistentContainer!
//    private weak var delegate:Delegate?
    static let shared=CDM()
    @Published var isLoaded:Bool?
    var loadingMsg=""
    private init(){
        setUpCoreDataStack()
    }
    private func setUpCoreDataStack(){
        persistentContainer = NSPersistentContainer(name: dataModelName)
        persistentContainer.loadPersistentStores {[weak self] persistentStoreDescription, error in
            if let self{
                if let error{
//                    delegate?.coreDataManager(isLoadPersistentStoresSuccess: false, errorMsg: error.localizedDescription)
                    self.loadingMsg="Error: \(error.localizedDescription)"
                    Utility.log(msg:loadingMsg)
                    self.isLoaded=false
                }else{
//                    delegate?.coreDataManager(isLoadPersistentStoresSuccess: true, errorMsg: nil)
                    let str = "Persistent Stores: \(persistentStoreDescription.type)"
                    self.loadingMsg="Success > NSPersistentStoreDescription : \(str)"
                    Utility.log(msg: loadingMsg)
                    self.isLoaded=true
                }
            }
        }
    }
    func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void){
        persistentContainer.performBackgroundTask(block)
    }
}
