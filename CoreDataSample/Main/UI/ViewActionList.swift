//
//  ViewActionList.swift
//  CoreDataSample
//
//  Created by Vijay Sachan on 15/03/25.
//

import SwiftUI
import SwiftUI

struct ListData: Identifiable {
    var id: String = UUID().uuidString
    let title: String
    let subTitle: String
    let view: () -> AnyView
}

struct ListSection {
    let name: String
    let items: [ListData]
}

struct ViewActionList: View {
    var body: some View {
        NavigationStack {
            List{
                ForEach(getSections(), id: \.name) { section in
                    Section(header: Text(section.name).font(.headline)) {
                        ForEach(section.items) { item in
                            NavigationLink(destination: item.view()) {
                                VStack(alignment: .leading) {
                                    Text(item.title)
                                        .font(.headline)
                                    Text(item.subTitle)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Core Data Actions")
        }
    }

    func getSections() -> [ListSection] {
        return [
            ListSection(name: "Basic Actions", items: [
                ListData(title: "Add Data", subTitle: "Insert new records", view: { AnyView(ViewCoreData()) }),
                ListData(title: "Memory Usage View", subTitle: "Memory Usage View", view: { AnyView(MemoryUsageView()) })
            ]),
            ListSection(name: "Advanced Actions", items: [
                ListData(title: "Update Data", subTitle: "Modify existing records", view: { AnyView(ViewCoreData()) }),
                ListData(title: "Delete Data", subTitle: "Remove stored records", view: { AnyView(ViewCoreData()) })
            ]),
            ListSection(name: "Migration", items: [
                ListData(title: "Lightweight Migration", subTitle: "Check CDManager",view: { AnyView(ViewCoreData()) }),
//                ListData(title: "Delete Data", subTitle: "Remove stored records", view: { AnyView(ViewCoreData()) })
            ])
        ]
    }
}
#Preview{
    NavigationStack {
        ViewActionList()
    }.environmentObject(AlertManager.shared)
}
