//
//  RequestPaymentView.swift
//  BillBuddy
//
//  Created by Callista Cleine on 12/6/2025.
//

import SwiftUI

struct RequestPaymentView: View {
    @EnvironmentObject var store: FriendStore
    let friend: Friend

    @State private var amount: Double = 0
    @State private var memo: String = ""
    @State private var isRequest = true

    // Formatter for decimals (two fraction digits)
    private let decimalFormatter: NumberFormatter = {
        let fmt = NumberFormatter()
        fmt.numberStyle = .decimal
        fmt.minimumFractionDigits = 2
        fmt.maximumFractionDigits = 2
        return fmt
    }()

    var body: some View {
            VStack(spacing: 24) {
                // Avatar placeholder
                Circle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 80, height: 80)

                Text(friend.name)
                    .font(.title2).bold()
                
                HStack(spacing: 0) {
                    Text("$")
                        .font(.system(size: 48, weight: .semibold, design: .rounded))
                    TextField("0.00", value: $amount, formatter: decimalFormatter)
                        .font(.system(size: 48, weight: .semibold, design: .rounded))
                        .keyboardType(.decimalPad)
                        .multilineTextAlignment(.leading)
                        .fixedSize()
                }
                .frame(maxWidth: .infinity)

                TextField("What's this for?", text: $memo)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)

                HStack(spacing: 16) {
                    Button("Request") { isRequest = true }
                        .buttonStyle(.borderedProminent)
                    Button("Pay")     { isRequest = false }
                        .buttonStyle(.bordered)
                }
            }
            .padding(.top, 40)
            .navigationTitle(friend.name)
            .navigationBarTitleDisplayMode(.inline)
        }
    }


struct RequestPaymentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            RequestPaymentView(
                friend: Friend(id: UUID(), name: "Callista", username: "ccleine", avatarURL: nil)
            )
            .environmentObject(FriendStore())
        }
    }
}
