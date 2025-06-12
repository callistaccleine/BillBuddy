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
  @State private var extractedText = ""
  @State private var parsedItems: [ReceiptItem] = []
  @State private var showConfirmSheet = false
    @State private var showText: Bool = false

  var body: some View {
    VStack(spacing: 20) {
      PhotosPicker(selection: $selectedItem, matching: .images) {
        Label("Upload Receipt", systemImage: "photo.on.rectangle")
          .padding()
          .frame(maxWidth: .infinity)
          .background(Color.blue)
          .foregroundColor(.white)
          .cornerRadius(12)
      }

      if !extractedText.isEmpty {
        ScrollView {
          Text(extractedText)
            .font(.caption)
            .foregroundColor(.secondary)
            .padding()
        }
      }
    }
    .padding()
    .onChange(of: selectedItem) { _ in
      Task {
        if let data = try? await selectedItem?.loadTransferable(type: Data.self),
           let img  = UIImage(data: data) {
          recognizeText(from: img)
        }
      }
    }
    .sheet(isPresented: $showConfirmSheet) {
      ConfirmParsedItemsView(receiptItems: parsedItems)
    }
  }

  private func recognizeText(from image: UIImage) {
    guard let cg = image.cgImage else { return }
    let handler = VNImageRequestHandler(cgImage: cg, options: [:])
    let request = VNRecognizeTextRequest { req, err in
      guard err == nil,
            let obs = req.results as? [VNRecognizedTextObservation]
      else { return print("OCR error:", err!) }

      let lines = obs
        .compactMap { $0.topCandidates(1).first?.string }
        .map     { $0.trimmingCharacters(in: .whitespaces) }

      DispatchQueue.main.async {
        extractedText = lines.joined(separator: "\n")
        parsedItems   = parse(lines: lines)
        showConfirmSheet = !parsedItems.isEmpty
      }
    }
    request.recognitionLevel = .accurate
    try? handler.perform([request])
  }

  private func parse(lines: [String]) -> [ReceiptItem] {
    let priceRX = try! NSRegularExpression(
      pattern: #"^\$?([\d,]+(?:\.\d{1,2})?)$"#
    )
    let ignore = ["ORDER", "SUBTOTAL", "TAX", "BALANCE", "HOST", "VISA", "BALANCE"]

    var items: [ReceiptItem] = []
    for (i, raw) in lines.enumerated() {
      let line = raw.trimmingCharacters(in: .whitespacesAndNewlines)
      guard !ignore.contains(where: { line.uppercased().hasPrefix($0) }) else {
        continue
      }

      let nsRange = NSRange(location: 0, length: (line as NSString).length)
      if let m = priceRX.firstMatch(in: line, range: nsRange) {
        let cap = (line as NSString).substring(with: m.range(at: 1))
          .replacingOccurrences(of: ",", with: ".")
        if let price = Double(cap),
           i > 0 {
          let name = lines[i-1].trimmingCharacters(in: .whitespacesAndNewlines)
          items.append(ReceiptItem(name: name, price: price, quantity: 1))
        }
      }
    }
    return items
  }
}
