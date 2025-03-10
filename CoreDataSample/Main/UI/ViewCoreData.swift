//
//  ViewCoreData.swift
//  CoreDataSample
//
//  Created by Vijay Sachan on 09/03/25.
//
import SwiftUI
struct ViewCoreData: View {
//    // ✅ Automatically fetches User data from Core Data
//        @FetchRequest(
//            entity: User.entity(),
//            sortDescriptors: [NSSortDescriptor(key: "createdAt", ascending: false)]
//        ) var users: FetchedResults<User>
    var body: some View{
        ZStack{
            Color.white
            VStack{
                Spacer().frame(height: 50) // Adds 50 points of top spacing
                Button("Add"){
                    User.saveUser()
                }.font(.title)
                Spacer()
//                List(users, id: \.self) { user in
//                                VStack(alignment: .leading) {
//                                    Text(user.name ?? "-").font(.headline)
//                                    Text(user.email ?? "-").font(.subheadline).foregroundColor(.gray)
//                                } 
//                            }
                
            }
        }.frame(maxWidth:.infinity,maxHeight: .infinity).onAppear(){
//            users=User.fetchUsers()
        }
    }
}
#Preview {
    ViewCoreData()
}
