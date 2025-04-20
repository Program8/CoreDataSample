//
//  RTFStyledViewer.swift
//  CoreDataSample
//
//  Created by Vijay Sachan on 20/04/25.
//

import SwiftUI

import SwiftUI

struct RTFStyledViewer: View {
    let fileName:String
    @State private var attributedText: AttributedString = AttributedString("Loading...")

    var body: some View {
        ScrollView {
            Text(attributedText)
                .padding()
        }
        .onAppear {
            loadRTFWithStyles()
        }
    }

    private func loadRTFWithStyles() {
        if let url = Bundle.main.url(forResource: fileName, withExtension: "rtf") {
            do {
                let data = try Data(contentsOf: url)
                if let nsAttributedString = try? NSAttributedString(data: data,
                                                                    options: [.documentType: NSAttributedString.DocumentType.rtf],
                                                                    documentAttributes: nil) {
                     let swiftUIAttributed = AttributedString(nsAttributedString)
                     self.attributedText = swiftUIAttributed
                }
            } catch {
                attributedText = AttributedString("⚠️ Failed to load RTF: \(error.localizedDescription)")
            }
        } else {
            attributedText = AttributedString("⚠️ RTF file not found in bundle.")
        }
    }
}


#Preview {
    RTFStyledViewer(fileName: R.RTFile.LightWeightMigration.name)
}
