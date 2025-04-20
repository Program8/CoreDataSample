//
//  CoreDataManager.swift
//  CoreDataSample
//
//  Created by Vijay Sachan on 09/03/25.
//
import Foundation
import CoreData
/// Core Data Manager
class CDManager:ObservableObject{
    
    let currentMigrationType = MigrationType.None
    
    var viewContext: NSManagedObjectContext { persistentContainer.viewContext }
    var newBgContext:NSManagedObjectContext{persistentContainer.newBackgroundContext()}
    //    var newBgContext:NSManagedObjectContext{viewContext}
    private let dataModelName:String="CoreDataModel"
    private var persistentContainer: NSPersistentContainer!
    //    private weak var delegate:Delegate?
    static let shared=CDManager()
    @Published var isLoaded:Bool?
    var loadingMsg=""
    private init(){
        setUpCoreDataStack()
    }
    private func setUpCoreDataStack(){
        persistentContainer = NSPersistentContainer(name: dataModelName)
        // MARK: Migration
        if currentMigrationType == .Lightweight && canMigrate(toVersion: 2){
            let description = persistentContainer.persistentStoreDescriptions.first
            description?.shouldMigrateStoreAutomatically = true
            description?.shouldInferMappingModelAutomatically = true
        }
        persistentContainer.loadPersistentStores {[weak self] persistentStoreDescription, error in
            if let self{
                if let error{
                    self.loadingMsg="Error: \(error.localizedDescription)"
                    Utility.log(msg:loadingMsg)
                    self.isLoaded=false
                }else{
                    self.loadingMsg="In this iOS app, you can see which stores are currently being used\n\n NSPersistentStoreDescription :\n\n\(getLoadedNSPersistentStoreDescription())"
                    Utility.log(msg: loadingMsg)
                    self.isLoaded=true
                   
                }
            }
        }
    }
    func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void){
        persistentContainer.performBackgroundTask(block)
    }
    func getLoadedNSPersistentStoreDescription()->String{
        var str=""
        let stores = persistentContainer.persistentStoreCoordinator.persistentStores
        let availableStoreType=StoreType.allCases
        for (index,store) in availableStoreType.enumerated(){
            var isAvailable=false
            if stores.contains(where: {store.value==$0.type}){
                isAvailable=true
            }
            str+=("\(index+1).  "+store.name+" "+(isAvailable ? Constants.Strings.tickmark+" (Using to save data)" : Constants.Strings.crossMark))+"\n"
        }
        return str
    }
    enum StoreType:CaseIterable{
        case SQLite,Binary,InMemory
        var name:String{
            switch self{
            case .SQLite:
                return "NSSQLiteStoreType"
            case .Binary:
                return "NSBinaryStoreType"
            case .InMemory:
                return "NSInMemoryStoreType"
            }
        }
        var value:String{
            switch self{
            case .SQLite:
                return NSSQLiteStoreType
            case .Binary:
                return NSBinaryStoreType
            case .InMemory:
                return NSInMemoryStoreType
            }
        }
    }
    enum MigrationType:String{
        case Lightweight,Staging,Manual,None
    }
}
extension CDManager{
    func canMigrate(toVersion version: Int) -> Bool {
        guard let modelBundleURL = Bundle.main.url(forResource: dataModelName, withExtension: "momd") else {
            Utility.log(msg: "❌ Failed to find model bundle for \(dataModelName).momd")
            return false
        }

        guard let sourceModelURL = Bundle(url: modelBundleURL)?.url(forResource: dataModelName, withExtension: "mom") else {
            Utility.log(msg: " ❌ Failed to find source model: \(dataModelName).mom")
            return false
        }

        guard let destinationModelURL = Bundle(url: modelBundleURL)?.url(forResource: "\(dataModelName) \(version)", withExtension: "mom") else {
            Utility.log(msg: "❌ Failed to find destination model: \(dataModelName) \(version).mom")
            return false
        }

        guard let sourceModel = NSManagedObjectModel(contentsOf: sourceModelURL) else {
            Utility.log(msg: "❌ Failed to load NSManagedObjectModel from source URL")
            return false
        }

        guard let destinationModel = NSManagedObjectModel(contentsOf: destinationModelURL) else {
            Utility.log(msg: "❌ Failed to load NSManagedObjectModel from destination URL")
            return false
        }
        let mappingModel = try? NSMappingModel.inferredMappingModel(forSourceModel: sourceModel, destinationModel: destinationModel)
        let val=mappingModel != nil
        Utility.log(msg:val ? "✅ Hurray! Can Migrate to Version \(version)" : "❌ Oops! Cannot Migrate to Version \(version)")
        return val
    }
}
