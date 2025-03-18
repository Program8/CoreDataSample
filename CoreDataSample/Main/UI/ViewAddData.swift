//
//  ViewAddData.swift
//  CoreDataSample
//
//  Created by Vijay Sachan on 16/03/25.
//
import SwiftUI
import CoreData
struct ViewAddData: View {
    @EnvironmentObject var alertManager: AlertManager
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var createdAt: Date = Date()
    @State private var entryCount: String = "1" // Default count
    @State private var disableButton=false
    @FocusState private var isTextFieldFocused: Bool // To dismiss keyboard
    @StateObject private var viewModel = UsersViewModel()
    let minEntries = 1
    let maxEntries = 10_00_000 // Adjust as needed
    let action: () -> Void
    @Environment(\.presentationMode) var presentationMode // For dismissing the view
    var body:some View {
        ZStack {
            Form{
                Section(header: Text("User Details")) {
                    TextField("Name", text: $name).onChange(of: name) {
                        validate()
                    }
                    TextField("Email", text: $email).onChange(of: email) {
                        validate()
                    }
                        .keyboardType(.emailAddress)
                }
                
                Section(header: Text("Entries")) {
                    VStack {
                        HStack{
                            Text("How many users to save")
                            Spacer()
                        }
                        TextField("Count", text: $entryCount)
                            .keyboardType(.numberPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .focused($isTextFieldFocused)
                            .onChange(of: entryCount) {
                                validate()
                            }
                        Button("Save \(entryCount) User(s)", action:saveUser).padding().buttonStyle(.borderedProminent).disabled(disableButton)
                        
                    }
                    Text("Allowed: \(minEntries)-\(maxEntries) entries").font(.caption).foregroundColor(.gray)
                }
                
            }
            FullScreenLoaderView(isLoading: $viewModel.showLoader)
            .navigationTitle("Add User")
            .navigationBarItems(trailing: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            }).globalAlert()
        }.onAppear(){
            validate()
        }
    }
    
    private func validate() {
        disableButton=true
        // Ensure only numeric values are allowed
        if let count = Int(entryCount), count >= minEntries, count <= maxEntries {
            entryCount = "\(count)" // Valid case
            if !name.isEmpty && !email.isEmpty{
                disableButton=false
            }
        }
        
    }
    
    private func saveUser() {
        viewModel.saveUser(noOfEntriesToSave: Int(entryCount)!, name: name, email: email){
            presentationMode.wrappedValue.dismiss() // Close form after saving
            action()
        }
    }
}



#Preview {
    ViewAddData(){
        
    }.environmentObject(AlertManager.shared)
}
