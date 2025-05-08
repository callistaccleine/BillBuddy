//
//  ReceiptReviewView.swift
//  BillBuddy
//
//  Created by Callista Cleine on 24/4/2025.
//

import SwiftUI
import UIKit
import VisionKit

struct ReceiptReviewView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var receipt: Receipt
    @State private var originalImage: UIImage?
    @State private var showingImagePreview = false
    @State private var editingItem: ReceiptItem?
    @State private var isAddingNewItem = false
    @State private var newItem = ReceiptItem(name: "", price: 0.0)
    @State private var showDatePicker = false
    
    init(extractedText: String, originalImage: UIImage?) {
        _receipt = State(initialValue: Receipt.parseFromOCR(text: extractedText))
        _originalImage = State(initialValue: originalImage)
    }
    
    init(receiptItems: [ReceiptItem]) {
        // Create a receipt with the provided items
        var newReceipt = Receipt()
        newReceipt.items = receiptItems
        
        // Initialize state variables
        _receipt = State(initialValue: newReceipt)
        _originalImage = State(initialValue: nil)
    }
    
    var body: some View {
            NavigationView {
                ScrollView {
                    VStack(spacing: 20) {
                        // Receipt Image Thumbnail
                        if let image = originalImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 120)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                )
                                .onTapGesture {
                                    showingImagePreview = true
                                }
                        } else {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.gray.opacity(0.1))
                                .frame(height: 120)
                                .overlay(
                                    Text("No image available")
                                        .foregroundColor(.gray)
                                )
                        }
                        
                        // Date Section
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Receipt Date")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            
                            HStack {
                                Text(formattedDate)
                                Spacer()
                                Button(action: {
                                    showDatePicker.toggle()
                                }) {
                                    Image(systemName: "calendar")
                                        .foregroundColor(.blue)
                                }
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                            
                            if showDatePicker {
                                DatePicker("", selection: $receipt.date, displayedComponents: [.date])
                                    .datePickerStyle(.wheel)
                                    .labelsHidden()
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(8)
                                    .transition(.opacity)
                            }
                        }
                        
                        // Items Section
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Items")
                                .font(.headline)
                                .padding(.top, 10)
                            
                            ForEach(receipt.items) { item in
                                itemCard(item)
                            }
                            
                            // Add Item Button
                            Button(action: {
                                isAddingNewItem = true
                                newItem = ReceiptItem(name: "", price: 0.0)
                            }) {
                                HStack {
                                    Spacer()
                                    Image(systemName: "plus.circle.fill")
                                    Text("Add Item")
                                    Spacer()
                                }
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.blue, style: StrokeStyle(lineWidth: 1, dash: [4]))
                                )
                                .foregroundColor(.blue)
                            }
                            
                            // Total Section
                            Divider()
                                .padding(.vertical)
                            
                            HStack {
                                Text("Subtotal")
                                    .font(.headline)
                                Spacer()
                                Text(String(format: "$%.2f", receipt.subtotal))
                                    .font(.headline)
                            }
                            .padding([.top, .horizontal])
                            
                            // Next Button
                            Button(action: {
                                // Process the validated receipt and continue
                                dismiss()
                            }) {
                                Text("Continue")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.blue)
                                    .cornerRadius(12)
                            }
                            .padding(.top)
                        }
                    }
                    .padding()
                }
                .navigationBarTitle("Review Receipt", displayMode: .inline)
                .navigationBarItems(
                    leading: Button("Cancel") { dismiss() },
                    trailing: Button("Next") {
                        // Process the validated receipt and continue
                        dismiss()
                    }
                )
                .sheet(isPresented: $showingImagePreview) {
                    if let image = originalImage {
                        ImagePreviewView(image: image)
                    }
                }
                .sheet(item: $editingItem) { item in
                    ItemEditView(item: item) { updatedItem in
                        if let index = receipt.items.firstIndex(where: { $0.id == updatedItem.id }) {
                            receipt.items[index] = updatedItem
                        }
                    } onDelete: { itemToDelete in
                        receipt.items.removeAll(where: { $0.id == itemToDelete.id })
                    }
                }
                .sheet(isPresented: $isAddingNewItem) {
                    ItemEditView(item: newItem, isNew: true) { item in
                        receipt.items.append(item)
                    } onDelete: { _ in
                        // Do nothing for new items
                    }
                }
            }
        }
        
        private var formattedDate: String {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            return formatter.string(from: receipt.date)
        }
        
        private func itemCard(_ item: ReceiptItem) -> some View {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.name)
                        .font(.body)
                        .fontWeight(.medium)
                    
                    Text("Quantity: \(item.quantity)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                Text(String(format: "$%.2f", item.price))
                    .fontWeight(.semibold)
                
                Button(action: {
                    editingItem = item
                }) {
                    Image(systemName: "pencil.circle.fill")
                        .foregroundColor(.blue)
                        .font(.title3)
                }
                .padding(.leading, 8)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
            )
        }
    }

    struct ImagePreviewView: View {
        @Environment(\.dismiss) private var dismiss
        let image: UIImage
        
        var body: some View {
            NavigationView {
                VStack {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                }
                .navigationBarTitle("Receipt Image", displayMode: .inline)
                .navigationBarItems(trailing: Button("Done") { dismiss() })
            }
        }
    }

    struct ItemEditView: View {
        @Environment(\.dismiss) private var dismiss
        @State private var editedItem: ReceiptItem
        let isNew: Bool
        let onSave: (ReceiptItem) -> Void
        let onDelete: (ReceiptItem) -> Void
        
        init(item: ReceiptItem, isNew: Bool = false, onSave: @escaping (ReceiptItem) -> Void, onDelete: @escaping (ReceiptItem) -> Void) {
            _editedItem = State(initialValue: item)
            self.isNew = isNew
            self.onSave = onSave
            self.onDelete = onDelete
        }
        
        var body: some View {
            NavigationView {
                Form {
                    Section(header: Text("Item Details")) {
                        TextField("Item name", text: $editedItem.name)
                        
                        Stepper("Quantity: \(editedItem.quantity)", value: $editedItem.quantity, in: 1...99)
                        
                        HStack {
                            Text("Price")
                            Spacer()
                            TextField("0.00", value: $editedItem.price, formatter: NumberFormatter.currencyFormatter)
                                .keyboardType(.decimalPad)
                                .multilineTextAlignment(.trailing)
                        }
                    }
                    
                    if !isNew {
                        Section {
                            Button(action: {
                                onDelete(editedItem)
                                dismiss()
                            }) {
                                HStack {
                                    Spacer()
                                    Text("Delete Item")
                                        .foregroundColor(.red)
                                    Spacer()
                                }
                            }
                        }
                    }
                }
                .navigationBarTitle(isNew ? "Add Item" : "Edit Item", displayMode: .inline)
                .navigationBarItems(
                    leading: Button("Cancel") { dismiss() },
                    trailing: Button("Save") {
                        onSave(editedItem)
                        dismiss()
                    }
                    .disabled(editedItem.name.isEmpty)
                )
            }
        }
    }

    // Number formatter for currency
    extension NumberFormatter {
        static var currencyFormatter: NumberFormatter {
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.currencySymbol = "$"
            return formatter
        }
    }

#Preview {
    ReceiptReviewView(
        extractedText: "Coffee $4.50\nBagel $3.25",
        originalImage: nil
    )
}
