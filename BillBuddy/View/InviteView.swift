//
//  InviteView.swift
//  BillBuddy
//
//  Created by Callista Cleine on 9/5/2025.
//
import SwiftUI

struct InviteView: View {
    @State private var contactInfo: String = ""
    @State private var showAlert = false

    var body: some View {
        VStack(spacing: 20) {
            Text("Invite a Friend")
                .font(.title2)
                .fontWeight(.bold)

            TextField("Enter email or phone number", text: $contactInfo)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.emailAddress) // switch to .phonePad if needed

            Button("Send Invite") {
                sendInvite()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)

            Spacer()
        }
        .padding()
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Invite Sent"), message: Text("An invite has been sent to \(contactInfo)."), dismissButton: .default(Text("OK")))
        }
    }

    func sendInvite() {
        // In real app: use backend or mail/SMS API
        showAlert = true
    }
}

