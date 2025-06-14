//
//  FriendStore.swift
//  BillBuddy
//
//  Created by Callista Cleine on 12/6/2025.
//
import SwiftUI

class FriendStore: ObservableObject {
    @Published var friends: [Friend] = [
        Friend(id: UUID(), name: "Michelle Marcelline", username: "Michelle-Marcelline", avatarURL: nil),
        Friend(id: UUID(), name: "Whissely Wijaya",    username: "Whissely_wijaya",    avatarURL: nil),
        Friend(id: UUID(), name: "Callista",           username: "ccleine",            avatarURL: nil),
        Friend(id: UUID(), name: "Kendall",            username: "Kendall2021",       avatarURL: nil),
        Friend(id: UUID(), name: "Catherine Jennifer",username: "CatherineJennifer",  avatarURL: nil)
    ]
    
    func markAsPaid(id: UUID) {
        // Remove the friend from the unpaid list (or update a flag, if you prefer)
        if let idx = friends.firstIndex(where: { $0.id == id }) {
            friends.remove(at: idx)
        }
    }
}

