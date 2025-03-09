//
//  Utility.swift
//  CoreDataSample
//
//  Created by Vijay Sachan on 09/03/25.
//

import Foundation

class Utility{
    static func log(file: String = #file, function: String = #function, line: Int = #line,msg:String) {
        let fileName = (file as NSString).lastPathComponent
        print("File: \(fileName), Function: \(function), Line: \(line), Msg: \(msg)")
    }
}
