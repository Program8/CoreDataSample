//
//  GlobalAlertModifier.swift
//  CoreDataSample
//
//  Created by Vijay Sachan on 14/03/25.
//

import SwiftUI

struct GlobalAlertModifier: ViewModifier {
    @EnvironmentObject var alertManager: AlertManager

    func body(content: Content) -> some View {
        content
            .alert(alertManager.title, isPresented: $alertManager.showAlert) {
                Button(alertManager.primaryButtonTitle, role: alertManager.buttonRole) {
                    alertManager.primaryButtonAction?()
                }
            } message: {
                Text(alertManager.message)
            }
    }
}

extension View {
    func globalAlert() -> some View {
        self.modifier(GlobalAlertModifier())
    }
}

