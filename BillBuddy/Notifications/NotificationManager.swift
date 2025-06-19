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
        UNUserNotificationCenter.current()
            .setNotificationCategories([billCategory])
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

    /// Schedule an immediate one-off notification
    func scheduleImmediateBillReminder(for friendID: UUID, amount: Double, ownerName: String) {
        let content = UNMutableNotificationContent()
        content.title = "You owe A$\(String(format: "%.2f", amount)) to \(ownerName)"
        content.body  = "Reminder sent just now."
        content.categoryIdentifier = NotificationIdentifier.billReminderCategory

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let requestID = "immediate-bill-\(friendID.uuidString)"
        let request = UNNotificationRequest(
            identifier: requestID,
            content: content,
            trigger: trigger
        )
        UNUserNotificationCenter.current().add(request)
    }

    /// Schedule a repeating daily reminder at the same time as dueDate
    func scheduleDailyBillReminder(for friendID: UUID, amount: Double, ownerName: String, at dueDate: Date) {
        let requestID = "daily-bill-\(friendID.uuidString)"

        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            let alreadyScheduled = requests.contains { $0.identifier == requestID }

            guard !alreadyScheduled else {
                print("📌 Daily reminder already scheduled for \(friendID)")
                return
            }

            let content = UNMutableNotificationContent()
            content.title = "Reminder: You still owe A$\(String(format: "%.2f", amount)) to \(ownerName)"
            content.body  = "Tap to mark as paid."
            content.categoryIdentifier = NotificationIdentifier.billReminderCategory

            var comps = DateComponents()
                    comps.hour = 18
                    comps.minute = 0
            let trigger = UNCalendarNotificationTrigger(dateMatching: comps, repeats: true)

            let request = UNNotificationRequest(identifier: requestID, content: content, trigger: trigger)

            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("❌ Failed to schedule daily reminder: \(error)")
                } else {
                    print("✅ Scheduled daily reminder at 5:00 PM for \(friendID)")
                }
            }
        }
    }

    /// MARK: - UNUserNotificationCenterDelegate
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        if response.actionIdentifier == NotificationIdentifier.markAsPaidAction {
            let rawID = response.notification.request.identifier
            // rawID format: "immediate-bill-<uuid>", "daily-bill-<uuid>", or "bill-<uuid>"
            let parts = rawID.split(separator: "-")
            if let uuidPart = parts.last,
               let friendID = UUID(uuidString: String(uuidPart)) {
                NotificationCenter.default.post(
                    name: .didMarkBillPaid,
                    object: friendID
                )
                UNUserNotificationCenter.current()
                    .removePendingNotificationRequests(withIdentifiers: [rawID])
            }
        }
        completionHandler()
    }
    }

