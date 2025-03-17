//
//  ViewCoreData.swift
//  CoreDataSample
//
//  Created by Vijay Sachan on 09/03/25.
//
import SwiftUI
struct ViewCoreData: View {
    @EnvironmentObject var alertManager: AlertManager
    @StateObject private var viewModel = UsersViewModel()
    @State var addData=false
    @State private var memoryUsage: String = "Calculating..."
    var body: some View{
        ZStack{
            VStack(spacing: 10){
                Spacer().frame(height: 10) // Adds 50 points of top spacing
                //                ViewButtonAddData(){
                //                    viewModel.fetchUsers()
                //                }
                Text("Memory Usage")
                                .font(.headline)
                            
                            Text(memoryUsage)
                                .font(.largeTitle)
                                .foregroundColor(.blue)
                                .padding()
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
//                        viewModel.countNoFaultObjects()
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
//                    updateMemoryUsage()
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
    func updateMemoryUsage() {
        DispatchQueue.global(qos: .userInteractive).async {
//                    while true {
                        let usage = getMemoryUsage()
                        DispatchQueue.main.async {
                            memoryUsage = String(format: "%.2f MB", usage)
                        }
//                        sleep(1) // Update every second
//                    }
                }
        }

        func getMemoryUsage() -> Double {
            var taskInfo = mach_task_basic_info()
            var count = mach_msg_type_number_t(MemoryLayout<mach_task_basic_info>.size) / 4
            
            let kerr = withUnsafeMutablePointer(to: &taskInfo) {
                $0.withMemoryRebound(to: integer_t.self, capacity: Int(count)) {
                    task_info(mach_task_self_, task_flavor_t(MACH_TASK_BASIC_INFO), $0, &count)
                }
            }

            if kerr == KERN_SUCCESS {
                return Double(taskInfo.resident_size) / (1024 * 1024) // Convert to MB
            } else {
                return -1 // Error case
            }
        }
}

#Preview {
    NavigationStack {
        ViewCoreData().environmentObject(AlertManager.shared)
    }
}
