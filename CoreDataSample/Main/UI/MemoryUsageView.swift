//
//  MemoryUsageView.swift
//  CoreDataSample
//
//  Created by Vijay Sachan on 17/03/25.
//

import SwiftUI

struct MemoryUsageView: View {
    @State private var memoryUsage: String = "Calculating..."

    var body: some View {
        VStack {
            Text("Memory Usage")
                .font(.headline)
            
            Text(memoryUsage)
                .font(.largeTitle)
                .foregroundColor(.blue)
                .padding()
            
            Button("Refresh") {
                updateMemoryUsage()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .onAppear {
            updateMemoryUsage()
        }
    }

    func updateMemoryUsage() {
        let usage = getMemoryUsage()
        memoryUsage = String(format: "%.2f MB", usage)
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

struct MemoryUsageView_Previews: PreviewProvider {
    static var previews: some View {
        MemoryUsageView()
    }
}


#Preview {
    MemoryUsageView()
}
