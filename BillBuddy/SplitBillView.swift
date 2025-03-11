//
//  SplitBillView.swift
//  BillBuddy
//
//  Created by Callista Cleine on 11/3/2025.
//

import SwiftUI

struct SplitBillView: View {
    @State private var totalCost = ""
    @State private var people = 2
    
    @State private var selectedFriends: [String] = []
    let friends = ["Alex", "Alecia", "Eleanor", "John", "Sophia"]

    // Function to calculate the total per person
    func calculateTotal() -> Double {
        let orderTotal = Double(totalCost) ?? 0
        let finalAmount = orderTotal
        return people > 0 ? finalAmount / Double(people) : 0
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                
                // Title
                Text("Split Bill")
                    .font(.system(size: 28, weight: .bold))
                    .padding(.top, 20)
                
                // Total Amount Input
                VStack(alignment: .leading, spacing: 8) {
                    Text("Enter Bill Amount")
                        .font(.headline)
                    TextField("Rp 0", text: $totalCost)
                        .keyboardType(.decimalPad)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                }
                .padding(.horizontal, 20)
                
                // Number of People Selection
                VStack(alignment: .leading, spacing: 8) {
                    Text("How many people?")
                        .font(.headline)
                    Picker("Number of people", selection: $people) {
                        ForEach(1..<25, id: \.self) { number in
                            Text("\(number) people")
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .frame(height: 100)
                }
                .padding(.horizontal, 20)
                
                // Friend Selection
                VStack(alignment: .leading, spacing: 8) {
                    Text("Select Friends")
                        .font(.headline)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(friends, id: \.self) { friend in
                                FriendSelectionView(name: friend, isSelected: selectedFriends.contains(friend)) {
                                    if selectedFriends.contains(friend) {
                                        selectedFriends.removeAll { $0 == friend }
                                    } else {
                                        selectedFriends.append(friend)
                                    }
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
                
                // Total Per Person
                VStack {
                    Text("Total per person")
                        .font(.headline)
                    Text("$ \(calculateTotal(), specifier: "%.2f")")
                        .font(.title)
                        .bold()
                        .foregroundColor(.blue)
                }
                .padding()
                
                Spacer()
                
                // Split Bill Button
                Button(action: {
                    print("Splitting Bill for \(people) people, including \(selectedFriends.count) friends")
                }) {
                    HStack {
                        Spacer()
                        Text("Split Bill")
                            .font(.headline)
                            .foregroundColor(.white)
                        Spacer()
                        Image(systemName: "arrow.right")
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(selectedFriends.isEmpty ? Color.gray : Color.blue)
                    .cornerRadius(10)
                    .frame(width: 250, height: 60)
                }
                .disabled(selectedFriends.isEmpty)
                
                Spacer()
            }
            .padding(.top, 20)
        }
    }
}

// Friend Selection Circle View
struct FriendSelectionView: View {
    let name: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        VStack {
            Button(action: action) {
                ZStack {
                    Circle()
                        .frame(width: 60, height: 60)
                        .foregroundColor(isSelected ? Color.blue.opacity(0.7) : Color(.systemGray5))
                    
                    Text(name.prefix(1)) // Show first letter as avatar
                        .font(.title)
                        .foregroundColor(.white)
                }
            }
            Text(name)
                .font(.caption)
                .foregroundColor(.black)
        }
        .padding(5)
    }
}

// Preview
#Preview {
    SplitBillView()
}

