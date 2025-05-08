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

    var body: some View {
        NavigationView {
            List {
                ForEach(availableFriends, id: \.self) { friend in
                    Button(action: {
                        toggleSelection(for: friend)
                    }) {
                        HStack {
                            Text(friend)
                            Spacer()
                            if selectedFriends.contains(friend) {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                }
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
}

