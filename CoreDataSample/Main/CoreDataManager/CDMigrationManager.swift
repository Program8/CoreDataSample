//
//  CDMigrationManager.swift
//  CoreDataSample
//
//  Created by Vijay Sachan on 27/04/25.
//
import Foundation
import CoreData
class CDMigrationManager{
    enum MigrationType:String{
        case Lightweight,Staging,Manual,None
    }
    /**
     This function checks if a lightweight migration is feasible between the source and destination data models by attempting to infer a mapping model.
     - Parameters:
       - dataModelNameFrom: The name of the source data model (without the `.mom` or `.momd` extension).Example Version 1 file name will be "CoreDataModel"
       - dataModelNameTo: The name of the destination data model (without the `.mom` or `.momd` extension).Example Version 2 file name will be "CoreDataModel 2"
     - Returns: A Boolean value indicating whether an inferred mapping model exists between the specified models (`true`) or not (`false`).
     - **Infer a mapping model** : It means that core data will automatically create a mapping mode file
     - Note: This function assumes that both data models are included in the application's bundle and that their names correspond to compiled `.mom` or `.momd` files.
     */
    func canMigrateByInferredMappingModel(dataModelNameFrom:String,dataModelNameTo:String) -> Bool {
        let dataModelName = CDManager.shared.dataModelName
        guard let modelBundleURL = Bundle.main.url(forResource: dataModelName, withExtension: "momd") else {
            Utility.log(msg: "❌ Failed to find model bundle for \(dataModelName).momd")
            return false
        }

        guard let sourceModelURL = Bundle(url: modelBundleURL)?.url(forResource: dataModelNameFrom, withExtension: "mom") else {
            Utility.log(msg: " ❌ Failed to find source model: \(dataModelNameFrom).mom")
            return false
        }

        guard let destinationModelURL = Bundle(url: modelBundleURL)?.url(forResource: dataModelNameTo, withExtension: "mom") else {
            Utility.log(msg: "❌ Failed to find destination model: \(dataModelNameTo).mom")
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
        Utility.log(msg:val ? "✅ Hurray! Can Migrate to Version \(dataModelNameFrom)" : "❌ Oops! Cannot Migrate to Version \(dataModelNameTo)")
        return val
    }
}
