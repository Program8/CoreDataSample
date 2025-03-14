//
//  AlertManager.swift
//  CoreDataSample
//
//  Created by Vijay Sachan on 14/03/25.
//
import SwiftUI

class AlertManager: ObservableObject {
    static let shared = AlertManager() // Singleton instance

    @Published var showAlert = false
    @Published var title: String = ""
    @Published var message: String = ""
    @Published var primaryButtonTitle: String = "OK"
    @Published var primaryButtonAction: (() -> Void)?
    @Published var buttonRole: ButtonRole? = nil

    func show(title: String, message: String, buttonTitle: String = "OK", role: ButtonRole? = nil, action: (() -> Void)? = nil) {
        self.title = title
        self.message = message
        self.primaryButtonTitle = buttonTitle
        self.primaryButtonAction = action
        self.buttonRole = role
        self.showAlert = true
    }
}
