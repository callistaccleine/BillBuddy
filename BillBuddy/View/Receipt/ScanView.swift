//
//  ScanView.swift
//  BillBuddy
//
//  Created by Callista Cleine on 23/4/2025.
//
import SwiftUI

struct ScanView: View {
    @State private var parsedItems: [ReceiptItem] = []
    @State private var showScanner = false
    @State private var scannedImage: UIImage?
    @State private var showImagePicker = false
    @State private var showManualEntry = false

    var body: some View {
        VStack(spacing: 24) {
            VStack(spacing: 8) {
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

            // ← Fix: opening brace added here
            VStack(spacing: 16) {
                Button {
                    showScanner = true
                } label: {
                    HStack {
                        Image(systemName: "camera")
                        Text("Scan Receipt")
                    }
                    .font(.system(size: 20, weight: .medium))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }

                Button {
                    showImagePicker = true
                } label: {
                    HStack {
                        Image(systemName: "photo")
                        Text("Upload Receipt")
                    }
                    .font(.system(size: 20, weight: .medium))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.white)
                    .foregroundColor(.black)
                    .cornerRadius(12)
                    .overlay(RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.gray.opacity(0.3)))
                }

                Button {
                    showManualEntry = true
                } label: {
                    HStack {
                        Image(systemName: "pencil.line")
                        Text("Enter Manually")
                    }
                    .font(.system(size: 20, weight: .medium))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.white)
                    .foregroundColor(.black)
                    .cornerRadius(12)
                    .overlay(RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1))
                }
            }
            .padding(.horizontal, 20)

            Spacer()
        }
        // present the document camera full screen
        .fullScreenCover(isPresented: $showScanner) {
            DocumentScannerView { result in
                switch result {
                case .success(let img):
                    scannedImage = img
                    showManualEntry = true
                case .failure(let err):
                    print("Scan failed:", err)
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


