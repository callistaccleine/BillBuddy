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
    @State private var showImagePicker = false
    @State private var isProcessingImage = false
    @State private var showManualEntry = false

    var body: some View {
        VStack (spacing:24){
            VStack (spacing:8){
                Text("Split Bill")
                    .font(.system(size: 32, weight: .bold))
                Text("Scan a receipt or enter items manually")
                    .font(.system(size: 17))
                    .foregroundColor(.secondary)
            }
            .padding(.top, 40)
            
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
            Spacer()

            // Action buttons
            VStack(spacing: 16) {
                // Scan Receipt Button
                Button {
                    showScanner = true
                } label: {
                    HStack {
                        Image(systemName: "camera")
                            .font(.system(size: 20))
                        Text("Scan Receipt")
                            .font(.system(size: 20, weight: .medium))
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
                // Upload Receipt Button
                Button {
                    showImagePicker = true
                } label: {
                    HStack {
                        Image(systemName: "photo")
                            .font(.system(size: 20))
                        Text("Upload Receipt")
                            .font(.system(size: 20, weight: .medium))
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.white)
                    .foregroundColor(.black)
                    .cornerRadius(12)
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.3)))
                }
                
                // Enter Manually Button
                Button {
                    showManualEntry = true
                } label: {
                    HStack {
                        Image(systemName: "pencil.line")
                            .font(.system(size: 20))
                        Text("Enter Manually")
                            .font(.system(size: 20, weight: .medium))
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.white)
                    .foregroundColor(.black)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
                }
            }
            .padding(.horizontal, 20)
            
            Spacer()
        }
        .sheet(isPresented: $showScanner) {
            DocumentScannerView { result in
                switch result {
                case .success(let image):
                    self.scannedImage = image
                    // Automatically go to manual entry after scan
                    self.showManualEntry = true
                case .failure(let error):
                    print("Scanning failed: \(error.localizedDescription)")
                }
                showScanner = false
            }
        }
        .sheet(isPresented: $showImagePicker) {
            UploadImage()
        }
        .sheet(isPresented: $showManualEntry) {
            ManualEntryView()
        }
    }
}

#Preview {
    ScanView()
}
