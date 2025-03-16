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
            VStack(spacing: 10){
                Spacer().frame(height: 10) // Adds 50 points of top spacing
                ViewButtonAddData(){
                    fetchData()
                }  
                List(viewModel.users.indices, id: \.self) { index in
                    let user = viewModel.users[index]
                    VStack(alignment: .leading) {
                        let no = viewModel.users.count - index  // Reverse numbering
                                    let name=user.name ?? "-"
                                    let dateTime=user.createdAt?.formatted() ?? "-"
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
        }.globalAlert().navigationTitle("Fetch Data")
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

}
#Preview {
    NavigationStack {
        ViewCoreData().environmentObject(AlertManager.shared)
    }
}
