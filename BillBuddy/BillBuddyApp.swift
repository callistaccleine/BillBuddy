//
//  BillBuddyApp.swift
//  BillBuddy
//
//  Created by Callista Cleine on 11/3/2025.
//

import SwiftUI
import Firebase


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
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                WelcomeView()
                SignUpView()
                LoginView()
                HomeView()
                ContentView()
                HomeView()
                ScanView()
                ManualEntryView()
            }
        }
    }
}
