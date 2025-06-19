// FriendStore.swift
// BillBuddy

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

/// Holds the current user's friends, loading from Firestore
final class FriendStore: ObservableObject {
    @Published var friends: [Friend] = []

    private var listener: ListenerRegistration? = nil

    init() {
        loadFriends()
    }

    deinit {
        listener?.remove()
    }

    /// Starts listening to the /users/{meUID}/friends subcollection
    func loadFriends() {
        guard let meUID = Auth.auth().currentUser?.uid else {
            self.friends = []
            return
        }

        let db = Firestore.firestore()
        listener = db
            .collection("users")
            .document(meUID)
            .collection("friends")
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self, let docs = snapshot?.documents else {
                    print("FriendStore load error:\(error?.localizedDescription ?? "none")")
                    return
                }

                var temp: [Friend] = []
                let group = DispatchGroup()

                // Each doc ID is the friendUID
                for doc in docs {
                    let friendUID = doc.documentID
                    group.enter()
                    db.collection("users")
                        .document(friendUID)
                        .getDocument { snap, err in
                            defer { group.leave() }
                            guard let data = snap?.data(), err == nil else { return }

                            // map your Firestore fields to Friend
                            let fullName = data["fullName"] as? String ?? ""
                            let username = data["email"] as? String ?? ""
                            let id = UUID(uuidString: friendUID) ?? UUID()

                            temp.append(
                                Friend(
                                    id: id,
                                    name: fullName,
                                    username: username,
                                    avatarURL: nil
                                )
                            )
                        }
                }

                // once all fetched, publish
                group.notify(queue: .main) {
                    self.friends = temp
                }
            }
    }

    /// Remove a friend from the unpaid list when they mark as paid
    func markAsPaid(id: UUID) {
        if let idx = friends.firstIndex(where: { $0.id == id }) {
            friends.remove(at: idx)
        }
    }
}
