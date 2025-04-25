//
//  ManualEntryView.swift
//  BillBuddy
//
//  Created by Callista Cleine on 24/4/2025.
//

import SwiftUI
import VisionKit

struct ManualEntryView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var receiptItems: [ReceiptItem] = []
    @State private var newItemName: String = ""
    @State private var newItemPrice: String = ""
    @State private var navigateToReview = false
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(receiptItems) { item in
                        HStack {
                            Text(item.name)
                            Spacer()
                            Text("$\(String(format: "%.2f", item.price))")
                        }
                    }
                    .onDelete(perform: deleteItems)
                    
                    HStack {
                        TextField("New item", text: $newItemName)
                        
                        Spacer()
                        
                        TextField("0.00", text: $newItemPrice)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 80)
                        
                        Button(action: addItem) {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.blue)
                        }
                    }
                }
                
                Divider()
                
                HStack {
                    Text("Total")
                        .font(.headline)
                    
                    Spacer()
                    
                    Text(totalAmount, format: .currency(code: "USD"))
                        .font(.headline)
                }
                .padding()
                
                Button("Continue") {
                    navigateToReview = true
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(12)
                .padding()
            }
            .navigationTitle("Enter Items")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .navigationDestination(isPresented: $navigateToReview) {
                ReceiptReviewView(receiptItems: receiptItems)
            }
        }
    }
    
    private var totalAmount: Double {
        receiptItems.reduce(0) { $0 + $1.price }
    }
    
    private func addItem() {
        guard !newItemName.isEmpty,
              let price = Double(newItemPrice.replacingOccurrences(of: ",", with: ".")) else {
            return
        }
        
        let newItem = ReceiptItem(name: newItemName, price: price)
        receiptItems.append(newItem)
        newItemName = ""
        newItemPrice = ""
    }
    
    private func deleteItems(at offsets: IndexSet) {
        receiptItems.remove(atOffsets: offsets)
    }
}

#Preview {
    ManualEntryView()
}

