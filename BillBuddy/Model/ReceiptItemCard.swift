//
//  ReceiptItemCard.swift
//  BillBuddy
//
//  Created by Callista Cleine on 11/5/2025.
//
import SwiftUI

struct ReceiptItemCard: View {
    let item: ReceiptItem
    let onEdit: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.name)
                        .font(.body)
                        .fontWeight(.medium)

                    Text("Quantity: \(item.quantity)")
                        .font(.subheadline)
                        .foregroundColor(.gray)

                    if !item.assignedFriends.isEmpty {
                        Text("Assigned to: \(item.assignedFriends.joined(separator: ", "))")
                            .font(.footnote)
                            .foregroundColor(.blue)
                    }
                }

                Spacer()

                Text(String(format: "$%.2f", item.price))
                    .fontWeight(.semibold)

                Button(action: onEdit) {
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
}

