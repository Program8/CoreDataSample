//
//  ViewCoreData.swift
//  CoreDataSample
//
//  Created by Vijay Sachan on 09/03/25.
//
import SwiftUI
struct ViewCoreData: View {
    @State var isLoading=false
    @State var users=[User]()
    var body: some View{
        ZStack{
            Color.white
            VStack{
                Spacer().frame(height: 50) // Adds 50 points of top spacing
                Button("Add"){
                    saveData()
                }.font(.title)
                Spacer()
                List(users, id: \.self) { user in
                                VStack(alignment: .leading) {
                                    let name=user.name ?? "-"
                                    let dateTime=user.createdAt?.formatted() ?? "-"
                                    Text((name+" "+dateTime)).font(.headline)
                                    Text(user.email ?? "-").font(.subheadline).foregroundColor(.gray)
                                    
                                }
                            }
                
            }
            FullScreenLoaderView(isLoading: $isLoading)
        }.frame(maxWidth:.infinity,maxHeight: .infinity).onAppear(){
            fetchData()
        }
    }
}
// MARK: Business logic
extension ViewCoreData{
    func fetchData(){
        isLoading=true
        User.fetchUsers(){ result in
            isLoading=false
            switch result{
            case .success(let arr):
                users=arr
            case .failure(_):
                users=[]
            }
            
        }
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
                break
            }
        }
    }
}

#Preview {
    ViewCoreData()
}
