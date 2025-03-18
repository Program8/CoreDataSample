//
//  ThreadManager.swift
//  CoreDataSample
//
//  Created by Vijay Sachan on 18/03/25.
//
import Foundation
class ThreadManager{
    static let shared=ThreadManager()
    var serialDispatchQueue=DispatchQueue(label: "Serial DispatchQueue")
    private init(){
        
    }
    
}
