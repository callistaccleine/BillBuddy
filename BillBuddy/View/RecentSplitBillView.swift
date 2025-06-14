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

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Title and notify button
            HStack {
                Text(item.name)
                    .font(.headline)
                    .foregroundColor(.primary)
                Spacer()
                Button(action: notifyUnpaidFriends) {
                    Image(systemName: "bell.fill")
                        .font(.title2)
                        .foregroundColor(.accentColor)
                }
                .accessibilityLabel("Notify unpaid friends")
            }


            // Total Bill with label normal and amount bold
            HStack(spacing: 4) {
                Text("Total Bill:")
                    .font(.subheadline)
                    .foregroundColor(.primary)
                Text("$\(String(format: "%.2f", item.price))")
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(.primary)
            }

            // Split with avatars + add button
            HStack(spacing: 20) {
                Text("Split with:")
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                // Friend initials
                ForEach(item.assignedFriends, id: \.self) { friendName in
                    let friend = store.friends.first { $0.name == friendName }
                    ProfileInitialsView(name: friend?.name ?? friendName)
                        .frame(width: 30, height: 10)
                        .font(.system(size: 5, weight: .medium))
                }

            }

            // Split Now action
            NavigationLink(destination:ReceiptReviewView(receiptItems: [item])) {
                    Text("Split Now")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
         }
        .padding()
        .background(Color(UIColor.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.primary.opacity(0.1), radius: 5)
    }
    // Schedule notifications for all unpaid friends
        private func notifyUnpaidFriends() {
            let dueDate = Date().addingTimeInterval(24 * 60 * 60) // replace with actual dueDate
            let share = item.price / Double(max(item.assignedFriends.count, 1))

            for friendName in item.assignedFriends {
                if let friend = store.friends.first(where: { $0.name == friendName }) {
                    NotificationManager.shared.scheduleBillReminder(
                        for: friend.id,
                        amount: share,
                        at: dueDate
                    )
                }
            }
        }
}

struct RecentSplitBillView_Previews: PreviewProvider {
    static var previews: some View {
        RecentSplitBillView(
            item: ReceiptItem(
                name: "Dinner at Café",
                price: 43.27,
                quantity: 1,
                assignedFriends: ["Alex", "Emma", "John", "Sophia"]
            )
        )
        .environmentObject(FriendStore())
        .preferredColorScheme(.light)

        RecentSplitBillView(
            item: ReceiptItem(
                name: "Dinner at Café",
                price: 43.27,
                quantity: 1,
                assignedFriends: ["Alex", "Emma", "John", "Sophia"]
            )
        )
        .environmentObject(FriendStore())
        .preferredColorScheme(.dark)
    }
}
