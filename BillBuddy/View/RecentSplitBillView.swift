//
//  RecentSplitBillView.swift
//  BillBuddy
//
//  Created by Callista Cleine on 14/6/2025.
//

import SwiftUI

struct RecentSplitBillView: View {
    let item: ReceiptItem
    @EnvironmentObject private var store: FriendStore
    @AppStorage("currentUserName") private var currentUserName: String = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 12) { // Reduced spacing
            // Title and notify button
            HStack {
                Text(item.name)
                    .font(.subheadline) // Made smaller
                    .foregroundColor(.primary)
                Spacer()
                Button(action: notifyUnpaidFriends) {
                    Image(systemName: "bell.fill")
                        .font(.subheadline) // Made smaller
                        .foregroundColor(.accentColor)
                }
                .accessibilityLabel("Notify unpaid friends")
            }

            // Total Bill with label normal and amount bold
            HStack(spacing: 4) {
                Text("Total Bill:")
                    .font(.caption) // Made smaller
                    .foregroundColor(.primary)
                Text("$\(String(format: "%.2f", item.price))")
                    .font(.caption) // Made smaller
                    .bold()
                    .foregroundColor(.primary)
            }

            // Split with avatars + add button
            HStack(spacing: 8) { // Reduced spacing
                Text("Split with:")
                    .font(.caption) // Made smaller
                    .foregroundColor(.secondary)
                
                HStack(spacing: 4) { // Reduced spacing
                    ForEach(item.assignedFriends, id: \.self) { friendName in
                        let friend = store.friends.first { $0.name == friendName }
                        ProfileInitialsView(name: friend?.name ?? friendName)
                    }
                }
            }

            // Split Now action
            NavigationLink(destination: ReceiptReviewView(receiptItems: [item])) {
                Text("Split Now")
                    .font(.subheadline) // Made smaller
                    .frame(maxWidth: .infinity)
                    .padding(8) // Reduced padding
                    .background(.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8) // Reduced corner radius
            }
        }
        .padding(12) // Reduced padding
        .background(Color(UIColor.systemBackground))
        .cornerRadius(10) // Reduced corner radius
        .shadow(color: Color.primary.opacity(0.1), radius: 3) // Reduced shadow
    }
    
    private func notifyUnpaidFriends() {
        let now = Date()
        let share = item.price / Double(max(item.assignedFriends.count, 1))

        for friendName in item.assignedFriends {
            guard let friend = store.friends.first(where: { $0.name == friendName }) else { continue }

            NotificationManager.shared.scheduleImmediateBillReminder(
                for: friend.id,
                amount: share,
                ownerName: currentUserName
            )

            let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: now) ?? now
            NotificationManager.shared.scheduleDailyBillReminder(
                for: friend.id,
                amount: share,
                ownerName: currentUserName,
                at: tomorrow
            )
        }
    }
}

struct RecentSplitBillView_Previews: PreviewProvider {
    static var previews: some View {
        RecentSplitBillView(item: ReceiptItem(
            name: "Dinner at Café",
            price: 43.27,
            quantity: 1,
            assignedFriends: ["Alex", "Emma", "John", "Sophia"]
        )
    )
    .environmentObject(FriendStore())
    }
}
