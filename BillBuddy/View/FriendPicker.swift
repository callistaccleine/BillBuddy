//
//  FriendPicker.swift
//  BillBuddy
//
//  Created by Callista Cleine on 9/5/2025.
//
import SwiftUI

struct FriendPickerView: View {
    let availableFriends: [String]
    @Binding var selectedFriends: [String]
    @Environment(\.dismiss) private var dismiss
    
    let columns = [
        GridItem(.adaptive(minimum: 80))
    ]

    var body: some View {
            NavigationView {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(availableFriends, id: \.self) { friend in
                            Button(action: {
                                toggleSelection(for: friend)
                            }) {
                                VStack(spacing: 8) {
                                    ZStack {
                                        Circle()
                                            .fill(selectedFriends.contains(friend) ? Color.blue.opacity(0.2) : Color.gray.opacity(0.1))
                                            .frame(width: 60, height: 60)

                                        Text(initials(for: friend))
                                            .font(.title2)
                                            .fontWeight(.bold)
                                            .foregroundColor(.blue)

                                        if selectedFriends.contains(friend) {
                                            Circle()
                                                .stroke(Color.blue, lineWidth: 3)
                                                .frame(width: 60, height: 60)
                                        }
                                    }

                                    Text(friend)
                                        .font(.caption)
                                        .lineLimit(1)
                                }
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding()
                }
                .navigationTitle("Select Friends")
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Done") {
                            dismiss()
                        }
                    }
                }
            }
        }

        private func toggleSelection(for friend: String) {
            if let index = selectedFriends.firstIndex(of: friend) {
                selectedFriends.remove(at: index)
            } else {
                selectedFriends.append(friend)
            }
        }

        private func initials(for name: String) -> String {
            let parts = name.split(separator: " ")
            let firstInitial = parts.first?.prefix(1) ?? ""
            let lastInitial = parts.last?.prefix(1) ?? ""
            return String(firstInitial + lastInitial)
        }
    }

    #Preview {
        FriendPickerView(
            availableFriends: ["Danny C.", "Jerry P.", "Richard A.", "Eden F."],
            selectedFriends: .constant(["Jerry P."])
        )
    }
