//
//  ScanView.swift
//  BillBuddy
//
//  Created by Callista Cleine on 23/4/2025.
//

import SwiftUI
import VisionKit

struct ScanView: View {
    @State private var showScanner = false
    @State private var scannedImage: UIImage?

    var body: some View {
        VStack {
            if let image = scannedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 300, maxHeight: 400)
                    .padding()
            } else {
                Text("No document scanned yet.")
                    .foregroundColor(.gray)
            }

            Button("Scan Document") {
                showScanner = true
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .sheet(isPresented: $showScanner) {
            DocumentScannerView { result in
                switch result {
                case .success(let image):
                    self.scannedImage = image
                case .failure(let error):
                    print("Scanning failed: \(error.localizedDescription)")
                }
                showScanner = false
            }
        }
    }
}
