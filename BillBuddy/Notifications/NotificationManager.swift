//
//  NotificationManager.swift
//  BillBuddy
//
//  Created by Callista Cleine on 14/6/2025.
//
// Handles registration, permission, scheduling, and delegate callbacks
import Foundation
import UserNotifications

final class NotificationManager: NSObject, UNUserNotificationCenterDelegate {
    static let shared = NotificationManager()

    private override init() {
        super.init()
    }

    /// Call at app launch to set up categories and request permission
    func configureNotifications() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        registerCategories()
        requestPermission()
    }

    /// Register actionable categories
    private func registerCategories() {
        let paidAction = UNNotificationAction(
            identifier: NotificationIdentifier.markAsPaidAction,
            title: "I’ve Paid",
            options: [.authenticationRequired]
        )
        let billCategory = UNNotificationCategory(
            identifier: NotificationIdentifier.billReminderCategory,
            actions: [paidAction],
            intentIdentifiers: [],
            options: []
        )
        UNUserNotificationCenter.current().setNotificationCategories([billCategory])
    }

    /// Prompt the user for notification permission
    private func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(
            options: [.alert, .sound, .badge]
        ) { granted, error in
            if let err = error {
                print("Notification auth error: \(err)")
            }
        }
    }

    /// Schedule a local reminder for an unpaid friend
    func scheduleBillReminder(for friendID: UUID,
                               amount: Double,
                               at dueDate: Date) {
        let content = UNMutableNotificationContent()
        content.title = "Hey, you owe A$\(String(format: "%.2f", amount))"
        content.body = "Tap to mark as paid."
        content.categoryIdentifier = NotificationIdentifier.billReminderCategory

        let comps = Calendar.current.dateComponents(
            [.year, .month, .day, .hour, .minute],
            from: dueDate
        )
        let trigger = UNCalendarNotificationTrigger(dateMatching: comps, repeats: false)
        let requestID = "bill-\(friendID.uuidString)"
        let request = UNNotificationRequest(
            identifier: requestID,
            content: content,
            trigger: trigger
        )
        UNUserNotificationCenter.current().add(request)
    }

    /// Delegate callback when an action is tapped
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        if response.actionIdentifier == NotificationIdentifier.markAsPaidAction {
            let rawID = response.notification.request.identifier
            let uuidString = rawID.replacingOccurrences(of: "bill-", with: "")
            if let friendID = UUID(uuidString: uuidString) {
                // Notify the app to mark as paid
                NotificationCenter.default.post(
                    name: .didMarkBillPaid,
                    object: friendID
                )
                // Remove pending request
                UNUserNotificationCenter.current()
                    .removePendingNotificationRequests(withIdentifiers: [rawID])
            }
        }
        completionHandler()
    }
}

