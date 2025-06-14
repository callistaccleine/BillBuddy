//
//  FriendListView.swift
//  BillBuddy
//
//  Created by Callista Cleine on 12/6/2025.
//

import SwiftUI

struct FriendListView: View {
    @EnvironmentObject var store: FriendStore
    @State private var searchText = ""

    private var filteredFriends: [Friend] {
        guard !searchText.isEmpty else { return store.friends }
        return store.friends.filter {
            $0.name.localizedCaseInsensitiveContains(searchText) ||
            $0.username.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        List {
            Section("Friends") {
                ForEach(filteredFriends) { friend in
                    NavigationLink(
                        destination: RequestPaymentView(friend: friend)
                            .environmentObject(store)
                    ) {
                        HStack(spacing: 12) {
                            Circle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(width: 40, height: 40)
                            VStack(alignment: .leading, spacing: 2) {
                                Text(friend.name)
                                    .font(.body).bold()
                                Text("@\(friend.username)")
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding(.vertical, 6)
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Friends")
        .searchable(
            text: $searchText,
            placement: .navigationBarDrawer(displayMode: .always),
            prompt: "Name, @username, phone…"
        )
    }
}

struct FriendListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            FriendListView()
                .environmentObject(FriendStore())
        }
    }
}
