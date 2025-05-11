//
//  ReceiptReviewView.swift
//  BillBuddy
//
//  Created by Callista Cleine on 24/4/2025.
//

import SwiftUI

struct ReceiptReviewView: View {
    let receiptItems: [ReceiptItem]

    private var total: Double {
        receiptItems.reduce(0) { result, item in
            result + (item.price * Double(item.quantity))
        }
    }

    private var friendTotals: [String: Double] {
        var totals: [String: Double] = [:]

        for item in receiptItems {
            let share = item.price * Double(item.quantity)
            let friends = item.assignedFriends
            guard !friends.isEmpty else { continue }
            let splitAmount = share / Double(friends.count)

            for friend in friends {
                totals[friend, default: 0.0] += splitAmount
            }
        }

        return totals
    }

    private func initials(for name: String) -> String {
        let parts = name.split(separator: " ")
        let first = parts.first?.prefix(1) ?? ""
        let last = parts.count > 1 ? parts.last?.prefix(1) ?? "" : ""
        return String(first + last)
    }

    var body: some View {
        VStack(spacing: 20) {
            Text("Split the Bill")
                .font(.title2)
                .fontWeight(.semibold)

            Text("Share in total \(friendTotals.count) Friends")
                .font(.subheadline)
                .foregroundColor(.gray)

            ScrollView {
                ForEach(friendTotals.sorted(by: { $0.key < $1.key }), id: \.key) { friend, amount in
                    HStack(spacing: 16) {
                        Circle()
                            .fill(Color.blue.opacity(0.2))
                            .frame(width: 40, height: 40)
                            .overlay(
                                Text(initials(for: friend))
                                    .font(.subheadline)
                                    .fontWeight(.bold)
                                    .foregroundColor(.blue)
                            )

                        VStack(alignment: .leading) {
                            Text(friend)
                                .fontWeight(.medium)
                            Text(String(format: "%.0f%%", 100 * (amount / total)))
                                .font(.caption)
                                .foregroundColor(.gray)
                        }

                        Spacer()

                        Text(String(format: "$%.2f", amount))
                            .fontWeight(.semibold)
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal)
                }
            }

            Divider()

            HStack {
                Text("Total Bill")
                    .fontWeight(.bold)
                Spacer()
                Text(String(format: "$%.2f", total))
                    .fontWeight(.bold)
            }
            .padding(.horizontal)

            Button(action: {
                // Send request logic here
            }) {
                HStack {
                    Image(systemName: "paperplane.fill")
                    Text("Send Request")
                        .fontWeight(.bold)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(12)
            }
            .padding(.horizontal)
        }
        .padding()
        //.navigationTitle("Review Split")
    }
}


#Preview {
    ReceiptReviewView(
        receiptItems: [
            ReceiptItem(name: "Coffee", price: 4.50, quantity: 1, assignedFriends: ["Alex"]),
            ReceiptItem(name: "Bagel", price: 3.25, quantity: 1, assignedFriends: ["Bella"])
        ]
    )
}
