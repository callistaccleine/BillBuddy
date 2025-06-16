//
//  ProfileView.swift
//  BillBuddy
//
//  Created by Callista Cleine on 16/6/2025.
//

import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    // User info
    @AppStorage("currentUserName") private var userName: String = ""
    @AppStorage("userEmail") private var userEmail: String = ""
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false

    // Saved card details (for easy top-up)
    @AppStorage("cardNumber") private var cardNumber: String = ""
    @AppStorage("cardExpiry") private var cardExpiry: String = ""
    @AppStorage("cardCVC") private var cardCVC: String = ""

    // Notification preferences
    @AppStorage("prefImmediateReminders") private var immediateReminders: Bool = true
    @AppStorage("prefDailyReminders") private var dailyReminders: Bool = true

    @State private var showingLogoutError = false

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Avatar & name
                ZStack(alignment: .bottomTrailing) {
                    Circle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 120, height: 120)
                    Button(action: {
                        // Edit avatar action
                    }) {
                        Image(systemName: "pencil.circle.fill")
                            .font(.title2)
                            .foregroundColor(.blue)
                            .background(Circle().fill(Color.white))
                    }
                    .offset(x: -8, y: -8)
                }
                Text(userName)
                    .font(.title2).bold()
                Text(userEmail)
                    .font(.subheadline).foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 30)

            // Payment Method
            VStack(alignment: .leading, spacing: 12) {
                Text("Payment Method")
                    .font(.headline)
                    .padding(.horizontal)
                VStack(spacing: 16) {
                    TextField("Card Number", text: $cardNumber)
                        .keyboardType(.numberPad)
                        .padding()
                        .background(Color(UIColor.secondarySystemBackground))
                        .cornerRadius(8)
                    HStack {
                        TextField("MM/YY", text: $cardExpiry)
                            .keyboardType(.numbersAndPunctuation)
                            .padding()
                            .background(Color(UIColor.secondarySystemBackground))
                            .cornerRadius(8)
                        TextField("CVC", text: $cardCVC)
                            .keyboardType(.numberPad)
                            .padding()
                            .background(Color(UIColor.secondarySystemBackground))
                            .cornerRadius(8)
                            .frame(width: 80)
                    }
                    if !cardNumber.isEmpty {
                        Text("Saved: \(maskedCard(cardNumber))")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding(.horizontal)
                    }
                }
                .padding(.horizontal)
            }
            .padding(.bottom, 30)

            // Notification Preferences
            VStack(alignment: .leading, spacing: 12) {
                Text("Notifications")
                    .font(.headline)
                    .padding(.horizontal)
                Toggle(isOn: $immediateReminders) {
                    Text("Immediate reminders")
                }
                .padding(.horizontal)
                Toggle(isOn: $dailyReminders) {
                    Text("Daily reminders")
                }
                .padding(.horizontal)
            }
            .padding(.bottom, 30)

            // Logout
            Button(role: .destructive) {
                do {
                    try Auth.auth().signOut()
                    isLoggedIn = false
                } catch {
                    showingLogoutError = true
                }
            } label: {
                Text("Logout")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red.opacity(0.1))
                    .foregroundColor(.red)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            .alert("Logout Failed", isPresented: $showingLogoutError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Unable to sign out. Please try again.")
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Profile")
    }

    private func maskedCard(_ number: String) -> String {
        let trimmed = number.replacingOccurrences(of: " ", with: "")
        guard trimmed.count >= 4 else { return number }
        let last4 = trimmed.suffix(4)
        return "•••• •••• •••• \(last4)"
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ProfileView()
        }
        .preferredColorScheme(.light)
        NavigationStack {
            ProfileView()
        }
        .preferredColorScheme(.dark)
    }
}
