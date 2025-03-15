//
//  ViewActionList.swift
//  CoreDataSample
//
//  Created by Vijay Sachan on 15/03/25.
//

import SwiftUI
struct ListData:Identifiable{
    var id: String { title }
    let title:String
    let view:AnyView
}
struct ViewActionList: View {
    var body: some View {
//            NavigationView {
                List(getList(), id: \.id) { item in
                    NavigationLink(destination: item.view) {
                        Text(item.title)
                            .font(.headline)
                            .padding()
                    }
                }
                .navigationTitle("Core Data Actions")
//            }
        }
    func getList()->[ListData]{
        var arr=[ListData]()
        arr.append(ListData(title: "Add Data",view: AnyView(ViewCoreData())))
        arr.append(ListData(title: "Fetch Data",view: AnyView(ViewCoreData())))
                   return arr
    }
}

#Preview {
    NavigationView {
        ViewActionList()
    }.environmentObject(AlertManager.shared)
}
