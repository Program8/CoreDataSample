//
//  FullScreenLoaderView.swift
//  CoreDataSample
//
//  Created by Vijay Sachan on 14/03/25.
//

import SwiftUI

struct FullScreenLoaderView: View{
    @Binding var isLoading: Bool
    var body: some View {
        ZStack{
            if isLoading {
                Color.black.opacity(0.1) // Semi-transparent background
                    .ignoresSafeArea().allowsHitTesting(true)
                VStack {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .scaleEffect(2)
                        .padding()
                    
                    Text("Please wait...")
                        .font(.headline)
                        .foregroundColor(.white)
                }
                .padding(20)
                .background(Color.gray.opacity(0.8))
                .cornerRadius(10)
            }
        }
        .animation(.easeInOut, value: isLoading)
    }
}




#Preview {
    @Previewable @State var loading=true
    FullScreenLoaderView(isLoading: $loading)
}
