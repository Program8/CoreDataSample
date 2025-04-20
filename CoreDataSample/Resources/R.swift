//
//  R.swift
//  CoreDataSample
//
//  Created by Vijay Sachan on 20/04/25.
//

import Foundation
class R{
    enum RTFile {
        case LightWeightMigration
        var name: String {
            switch self {
            case .LightWeightMigration:
                return "LightWeight Migration"
            }
        }
    }
}
