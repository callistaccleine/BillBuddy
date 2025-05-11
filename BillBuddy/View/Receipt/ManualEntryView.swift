//
//  ManualEntryView.swift
//  BillBuddy
//
//  Created by Callista Cleine on 24/4/2025.
//

import SwiftUI
import VisionKit
import UIKit
import Combine

struct ManualEntryView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var receiptItems: [ReceiptItem] = []
    @State private var newItemName: String = ""
    @State private var newItemPrice: String = ""
    @State private var newItemQuantity: Int = 1
    @State private var navigateToReview = false
    @State private var currentlySelectedFriend: String? = nil
    @State private var availableFriends = ["Alex", "Bella", "Charlie", "Daniel"]
    @FocusState private var isInputFocused: Bool

    var body: some View {
        NavigationView {
            ScrollViewReader { scrollProxy in
                ScrollView {
                    VStack(spacing: 16) {
                        Text("Enter Items")
                            .font(.largeTitle)
                            .bold()
                            .padding(.horizontal)
                            .padding(.top)

                        // Friend Avatars
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(availableFriends, id: \.self) { friend in
                                    VStack(spacing: 4) {
                                        ZStack {
                                            Circle()
                                                .fill(currentlySelectedFriend == friend ? Color.blue.opacity(0.2) : Color.gray.opacity(0.1))
                                                .frame(width: 60, height: 60)

                                            Text(initials(for: friend))
                                                .font(.title2)
                                                .fontWeight(.bold)
                                                .foregroundColor(.blue)

                                            if currentlySelectedFriend == friend {
                                                Circle()
                                                    .stroke(Color.blue, lineWidth: 2)
                                                    .frame(width: 60, height: 60)
                                            }
                                        }
                                        Text(friend)
                                            .font(.caption2)
                                            .lineLimit(1)
                                    }
                                    .onTapGesture {
                                        currentlySelectedFriend = currentlySelectedFriend == friend ? nil : friend
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }

                        // Item List
                        VStack(spacing: 12) {
                            ForEach(receiptItems.indices, id: \.self) { index in
                                let item = receiptItems[index]
                                VStack(alignment: .leading, spacing: 4) {
                                    HStack {
                                        VStack(alignment: .leading) {
                                            Text(item.name).font(.headline)
                                            Text("Quantity: \(item.quantity)").font(.caption).foregroundColor(.gray)
                                        }
                                        Spacer()
                                        Text("A$\(String(format: "%.2f", item.price))")
                                    }
                                    .contentShape(Rectangle())
                                    .onTapGesture {
                                        if let selected = currentlySelectedFriend {
                                            if item.assignedFriends.contains(selected) {
                                                receiptItems[index].assignedFriends.removeAll { $0 == selected }
                                            } else {
                                                receiptItems[index].assignedFriends.append(selected)
                                            }
                                        }
                                    }

                                    if !item.assignedFriends.isEmpty {
                                        ScrollView(.horizontal, showsIndicators: false) {
                                            HStack {
                                                ForEach(item.assignedFriends, id: \.self) { friend in
                                                    Circle()
                                                        .fill(Color.blue.opacity(0.2))
                                                        .frame(width: 30, height: 30)
                                                        .overlay(
                                                            Text(initials(for: friend))
                                                                .font(.caption)
                                                                .foregroundColor(.blue)
                                                        )
                                                }
                                            }
                                        }
                                    }
                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(8)
                                .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
                                .padding(.horizontal)
                            }
                        }

                        // Add item section
                        VStack(spacing: 12) {
                            TextField("Item Name", text: $newItemName)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(8)
                                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.3)))
                                .focused($isInputFocused)

                            HStack {
                                Stepper("Quantity: \(newItemQuantity)", value: $newItemQuantity, in: 1...99)
                                Spacer()
                                TextField("$0.00", text: $newItemPrice)
                                    .keyboardType(.decimalPad)
                                    .multilineTextAlignment(.trailing)
                                    .frame(width: 80)
                                    .padding(8)
                                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.3)))
                            }

                            Button(action: addItem) {
                                HStack {
                                    Image(systemName: "plus.circle.fill")
                                    Text("Add Item")
                                }
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(RoundedRectangle(cornerRadius: 8).stroke(Color.blue, style: StrokeStyle(lineWidth: 1, dash: [4])))
                                .foregroundColor(.blue)
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                        .padding(.horizontal)

                        // Continue Button
                        Button("Continue") {
                            navigateToReview = true
                        }
                        .disabled(receiptItems.contains { $0.assignedFriends.isEmpty })
                        .opacity(receiptItems.contains { $0.assignedFriends.isEmpty } ? 0.5 : 1.0)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .padding()

                        NavigationLink(destination: ReceiptReviewView(receiptItems: receiptItems), isActive: $navigateToReview) {
                            EmptyView()
                        }
                    }
                    .padding(.bottom, isInputFocused ? 300 : 0)
                }
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle("")
            }
        }
    }

    private func initials(for name: String) -> String {
        let parts = name.split(separator: " ")
        let firstInitial = parts.first?.prefix(1) ?? ""
        let lastInitial = parts.last?.prefix(1) ?? ""
        return String(firstInitial + lastInitial)
    }

    private func addItem() {
        guard !newItemName.isEmpty,
              let price = Double(newItemPrice.replacingOccurrences(of: ",", with: ".")) else {
            return
        }

        let newItem = ReceiptItem(name: newItemName, price: price, quantity: newItemQuantity)
        receiptItems.append(newItem)
        newItemName = ""
        newItemPrice = ""
        newItemQuantity = 1
    }
}

#Preview {
    ManualEntryView()
}
