//
//  ConfirmParsedItemsView.swift
//  BillBuddy
//
//  Created by Callista Cleine on 12/6/2025.
//
import SwiftUI

struct ConfirmParsedItemsView: View {
    @State var receiptItems: [ReceiptItem]
    @Environment(\.dismiss) private var dismiss

    // formatter for inline price editing
    private let priceFormatter: NumberFormatter = {
        let f = NumberFormatter()
        f.numberStyle           = .decimal
        f.minimumFractionDigits = 0
        f.maximumFractionDigits = 2
        return f
    }()

    var body: some View {
        NavigationStack {
            List {
                ForEach($receiptItems.indices, id: \.self) { idx in
                    let itemBinding = $receiptItems[idx]
                    HStack {
                        TextField("Name", text: itemBinding.name)
                        Spacer()
                        TextField("A$0.00",
                                  value: itemBinding.price,
                                  formatter: priceFormatter)
                            .keyboardType(.decimalPad)
                            .frame(width: 80)
                        Stepper("", value: itemBinding.quantity, in: 1...99)
                            .labelsHidden()
                    }
                    .padding(.vertical, 4)
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Confirm Items")
            .navigationBarItems(
                          leading:
                            Button("Cancel", action: { dismiss() })
                        )

            // Continue to the real ReceiptReviewView
            NavigationLink {
                ManualEntryView(initialItems: receiptItems)
            } label: {
                Text("Continue and Edit")
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .padding()
            }
            .disabled(receiptItems.isEmpty)
        }
    }
}

