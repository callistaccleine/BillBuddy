//
//  Receipt.swift
//  BillBuddy
//
//  Created by Callista Cleine on 25/4/2025.
//

import SwiftUI
import VisionKit

struct Receipt {
    var date: Date = Date()
    var items: [ReceiptItem] = []
    var rawText: String = ""
    
    // Calculate subtotal
    var subtotal: Double {
        items.reduce(0) { $0 + ($1.price * Double($1.quantity)) }
    }
    
    // Parse raw OCR text into structured receipt data
    static func parseFromOCR(text: String) -> Receipt {
        var receipt = Receipt(rawText: text)
        
        // Basic parsing logic - this would need refinement for real-world use
        let lines = text.components(separatedBy: .newlines)
        
        // Try to extract date
        if let dateString = lines.first(where: { $0.lowercased().contains("date") }) {
            // Process date string here
        }
        
        // Extract items and prices - very basic implementation
        var items: [ReceiptItem] = []
        
        for line in lines {
            // Look for lines with price patterns like $00.00
            if let range = line.range(of: #"\$\d+\.\d{2}"#, options: .regularExpression) {
                let priceString = String(line[range])
                let priceValue = Double(priceString.dropFirst()) ?? 0.0
                
                // Extract name - everything before the price
                let nameEndIndex = line.range(of: #"\$"#, options: .regularExpression)?.lowerBound ?? line.endIndex
                let name = line[..<nameEndIndex].trimmingCharacters(in: .whitespaces)
                
                if !name.isEmpty && priceValue > 0 {
                    items.append(ReceiptItem(name: name, price: priceValue))
                }
            }
        }
        
        receipt.items = items
        return receipt
    }
}
