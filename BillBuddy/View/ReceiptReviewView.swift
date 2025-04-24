//
//  ReceiptReviewView.swift
//  BillBuddy
//
//  Created by Callista Cleine on 24/4/2025.
//

import SwiftUI

struct ReceiptReviewView: View {
    var receiptItems: [ReceiptItem]

    var body: some View {
        VStack(alignment: .leading) {
            Text("Review Items")
                .font(.title)
                .padding(.bottom, 10)

            List(receiptItems) { item in
                HStack {
                    Text(item.name)
                    Spacer()
                    Text("$\(String(format: "%.2f", item.price))")
                }
            }

            Spacer()
        }
        .padding()
        .navigationTitle("Review")
    }
}

#Preview {
    ReceiptReviewView(receiptItems: [
        ReceiptItem(name: "Coffee", price: 4.50),
        ReceiptItem(name: "Bagel", price: 3.25)
    ])
}
