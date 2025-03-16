//
//  ViewButtonAddData.swift
//  CoreDataSample
//
//  Created by Vijay Sachan on 16/03/25.
//

import SwiftUI

struct ViewButtonAddData: View {
    let action: () -> Void
    @State private var showAddUserForm = false
    var body: some View {
        HStack{
            Spacer()
            Color.clear
            Button(action: {
                showAddUserForm = true
            }) {
                Label("Add Data", systemImage: "plus")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .clipShape(.capsule)
            }
        }.frame(height: 50).sheet(isPresented: $showAddUserForm) {
            ViewAddData(){
                action()
            }
        }
    }
}

#Preview {
    ViewButtonAddData(action: {
        
    })
}
