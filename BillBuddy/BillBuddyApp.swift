//
//  BillBuddyApp.swift
//  BillBuddy
//
//  Created by Callista Cleine on 11/3/2025.
//

import SwiftUI
import Firebase
import UserNotifications


class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct BillBuddyApp: App {
    // Inject AppDelegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    // Shared friend store
    @StateObject private var store = FriendStore()
    // Authentication flag
    @AppStorage("isLoggedIn") private var isLoggedIn = false

    init() {
        // Configure notifications on launch
        NotificationManager.shared.configureNotifications()
    }

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                if isLoggedIn {
                    HomeView()
                        .environmentObject(store)
                } else {
                    WelcomeView()
                }
            }
            .id(isLoggedIn)
            // Listen for “I’ve Paid” actions
            .onReceive(
                NotificationCenter.default.publisher(for: .didMarkBillPaid)
            ) { notification in
                if let friendID = notification.object as? UUID {
                    store.markAsPaid(id: friendID)
                }
            }
        }
    }
}
