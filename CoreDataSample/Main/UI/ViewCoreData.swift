//
//  ViewCoreData.swift
//  CoreDataSample
//
//  Created by Vijay Sachan on 09/03/25.
//
import SwiftUI
struct ViewCoreData: View {
    @EnvironmentObject var alertManager: AlertManager
    @State var isLoading=false
    @StateObject private var viewModel = UsersViewModel(context: CDM.shared.viewContext)
    var body: some View{
        ZStack{
            Color.white
            VStack{
                Spacer().frame(height: 50) // Adds 50 points of top spacing
                Button("Add"){
//                    for _ in 1...100{
                        saveData()
//                    }
                }.font(.title)
                Spacer()
                List(viewModel.users, id: \.objectID) { user in
                                VStack(alignment: .leading) {
                                    let no=1//(viewModel.users.count-index)
                                    let name=""//user.name ?? "-"
                                    let dateTime=""//user.createdAt?.formatted() ?? "-"
                                    let email=user.email ??  "-"
                                    Text(("\(no). "+name+" "+dateTime)).font(.headline)
                                    Text(email).font(.subheadline).foregroundColor(.gray)
                                     
                                }.onAppear(){
                                    let count=self.viewModel.users.filter({!$0.isFault}).count
                                    print("Data loaded for = \(count) objects")
                                    
                                }
                            }
                
            }
            FullScreenLoaderView(isLoading: $isLoading)
        }.frame(maxWidth:.infinity,maxHeight: .infinity).onAppear(){
            self.viewModel.fetchUsers()
        }.globalAlert()
    }
}
// MARK: Business logic
extension ViewCoreData{
    func fetchData(){
        self.viewModel.fetchUsers()
//        isLoading=true
//        User.fetchUsers(){ result in
//            isLoading=false
//            switch result{
//            case .success(let arr):
//                users=arr
//            case .failure(let error):
//                users=[]
//                alertManager.title=Constants.Strings.errorOccurred
//                alertManager.message=error.localizedDescription
//                alertManager.showAlert=true
//            }
//            
//        }
    }
    func saveData(){
        isLoading=true
        User.saveUser(){result in
            isLoading=false
            switch result{
            case .success(_):
                fetchData()
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
    ViewCoreData().environmentObject(AlertManager.shared)
}
