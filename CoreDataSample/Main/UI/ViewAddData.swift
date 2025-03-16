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
    @State var isLoading=false
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var createdAt: Date = Date()
    @State private var entryCount: String = "1" // Default count
    @FocusState private var isTextFieldFocused: Bool // To dismiss keyboard

    let minEntries = 1
    let maxEntries = 1000 // Adjust as needed
    let action: () -> Void

    @Environment(\.presentationMode) var presentationMode // For dismissing the view

    var body:some View {
        ZStack {
            Form{
                Section(header: Text("User Details")) {
                    TextField("Name", text: $name)
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                }
                
                Section(header: Text("Entries")) {
                    HStack {
                        TextField("Count", text: $entryCount)
                            .keyboardType(.numberPad)
                            .frame(width: 80)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .focused($isTextFieldFocused)
                            .onChange(of: entryCount) {
                                validateEntryCount()
                            }
                            .toolbar {
                                ToolbarItem(placement: .keyboard) {
                                    Button("Done") {
                                        isTextFieldFocused = false
                                    }
                                }
                            }
                        
                        Button(action: saveUser) {
                            Label("Save User(s)", systemImage: "checkmark.circle.fill")
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(8)
                        }
                    }
                    Text("Allowed: \(minEntries)-\(maxEntries) entries").font(.caption).foregroundColor(.gray)
                }
                
            }
            FullScreenLoaderView(isLoading: $isLoading)
            .navigationTitle("Add User")
            .navigationBarItems(trailing: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            }).globalAlert()
        }
    }
    
    private func validateEntryCount() {
        // Ensure only numeric values are allowed
        if let count = Int(entryCount), count >= minEntries, count <= maxEntries {
            entryCount = "\(count)" // Valid case
        } else if let count = Int(entryCount) {
            entryCount = "\(min(max(count, minEntries), maxEntries))" // Clamp within range
        } else {
            entryCount = "\(minEntries)" // Reset to minimum if invalid
        }
    }
    
    private func saveUser() {
        isLoading=true
        User.saveUser(noOfEntriesToSave: Int(entryCount)!, name: name, email: email){ result in
            isLoading=false
            switch result{
            case .success(_):
                presentationMode.wrappedValue.dismiss() // Close form after saving
                action()
                break
            case .failure(let error):
                alertManager.title=Constants.Strings.errorOccurred
                alertManager.message=error.localizedDescription
                alertManager.showAlert=true
                
            }
            
        }
    }
}



#Preview {
    ViewAddData(){
        
    }.environmentObject(AlertManager.shared)
}
