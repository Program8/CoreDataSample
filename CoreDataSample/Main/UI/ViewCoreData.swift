//
//  ViewCoreData.swift
//  CoreDataSample
//
//  Created by Vijay Sachan on 09/03/25.
//
import SwiftUI
struct ViewCoreData: View {
    @EnvironmentObject var alertManager: AlertManager
    @StateObject private var viewModel = UsersViewModel(context: CDM.shared.viewContext)
    @State var addData=false
    var body: some View{
        ZStack{
            VStack(spacing: 10){
                Spacer().frame(height: 10) // Adds 50 points of top spacing
                //                ViewButtonAddData(){
                //                    viewModel.fetchUsers()
                //                }
                HStack(alignment: .top,spacing: 10){
                    Text("Total Users\n\(viewModel.totalUsers)").multilineTextAlignment(.center)
                    Text("Total User(NSManagedObject) data loaded in memory\n\(viewModel.totalUsersDataInMemory)").multilineTextAlignment(.center)
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
                        //                        Text("Data in memory").foregroundStyle(user.isFault ? Color.red : Color.green)
                    }.onAppear(){
                        viewModel.countNoFaultObjects()
                    }
                }
                
            }
            FullScreenLoaderView(isLoading: $viewModel.showLoader)
        }.frame(maxWidth:.infinity,maxHeight: .infinity).onAppear(){
            self.viewModel.fetchUsers()
        }.navigationTitle("Fetch Data").toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    addData=true
                }) {
                    HStack {
                        Image(systemName: "plus")
                        Text("Add Data")
                    }
                }
            }
        }.globalAlert().sheet(isPresented: $addData) {
            ViewAddData(){
                viewModel.fetchUsers()
            }
        }
    }
}

#Preview {
    NavigationStack {
        ViewCoreData().environmentObject(AlertManager.shared)
    }
}
