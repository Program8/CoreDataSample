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
    
    let currentMigrationType = MigrationType.Lightweight
    
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
        if currentMigrationType == .Lightweight {
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
    enum MigrationType{
        case Lightweight,Staging,Manual,None
        
    }
}
