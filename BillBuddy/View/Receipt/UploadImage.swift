//
//  UploadImage.swift
//  BillBuddy
//
//  Created by Callista Cleine on 25/4/2025.
//

import SwiftUI
import PhotosUI
import Vision

struct UploadImage: View {
    @State private var selectedItem: PhotosPickerItem?
    @State private var extractedText: String = ""
    @State private var showText: Bool = false

    var body: some View {
        VStack(spacing: 20) {
            PhotosPicker(
                selection: $selectedItem,
                matching: .images,
                photoLibrary: .shared()
            ) {
                HStack {
                    Image(systemName: "photo.on.rectangle")
                    Text("Upload Receipt")
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(12)
            }

            if showText {
                ScrollView {
                    Text(extractedText)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
        .padding()
        .onChange(of: selectedItem) {
            Task {
                if let data = try? await selectedItem?.loadTransferable(type: Data.self),
                   let uiImage = UIImage(data: data) {
                    recognizeText(from: uiImage)
                }
            }
        }
    }

    private func recognizeText(from image: UIImage) {
        guard let cgImage = image.cgImage else { return }

        let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        let request = VNRecognizeTextRequest { request, error in
            guard error == nil else {
                print("Text recognition failed: \(error!.localizedDescription)")
                return
            }

            let observations = request.results as? [VNRecognizedTextObservation] ?? []
            let recognizedStrings = observations.compactMap {
                $0.topCandidates(1).first?.string
            }

            DispatchQueue.main.async {
                self.extractedText = recognizedStrings.joined(separator: "\n")
                self.showText = true
            }
        }

        request.recognitionLevel = .accurate
        try? requestHandler.perform([request])
    }
}
