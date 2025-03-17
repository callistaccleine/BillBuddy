//
//  HomeView.swift
//  BillBuddy
//
//  Created by Callista Cleine on 17/3/2025.
//

import SwiftUI

import SwiftUI

struct HomeView: View {
    // Sample User Data
    let userName = "Bella" // Change this dynamically
    let balance: Double = 13470.00
    
    let recentSplits: [SplitBill] = [
        SplitBill(id: 1, place: "CFC Sukabumi", amount: 43.27, people: ["Alex", "Emma", "John", "Sophia"]),
        SplitBill(id: 2, place: "Starbucks", amount: 23.50, people: ["Mike", "Eleanor"])
    ]
    
    let recentActivity: [Transaction] = [
        Transaction(id: 1, friend: "Alex", description: "paid for Dinner", amount: 45.00, date: "March 16, 2025"),
        Transaction(id: 2, friend: "Emma", description: "paid for Uber", amount: 18.75, date: "March 15, 2025")
    ]

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    
                    // MARK: - Header (User Profile + Greeting)
                    HStack {
                        // Profile Icon with Initials
                        ProfileInitialsView(name: userName)
                        
                        VStack(alignment: .leading) {
                            Text("Hi, \(userName)")
                                .font(.title2)
                                .fontWeight(.bold)
                            Text("Welcome back!")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            print("Menu tapped")
                        }) {
                            Image(systemName: "line.horizontal.3")
                                .font(.title)
                                .foregroundColor(.black)
                        }
                    }
                    .padding(.horizontal)
                    
                    // MARK: - Balance Card
                    VStack {
                        Text("Your Balance")
                            .font(.headline)
                            .foregroundColor(.gray)
                        Text("$\(String(format: "%.2f", balance))")
                            .font(.system(size: 32, weight: .bold))
                    }
                    .frame(width: 350, height: 120)
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(color: .gray.opacity(0.2), radius: 5)
                    
                    // MARK: - Recent Billing
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text("Recent Billing")
                                .font(.headline)
                            Spacer()
                            NavigationLink(destination: Text("All Splits")) {
                                Text("View all")
                                    .foregroundColor(.blue)
                                    .font(.subheadline)
                            }
                        }
                        .padding(.horizontal)

                        ForEach(recentSplits) { split in
                            RecentSplitBillView(split: split)
                        }
                    }
                    
                    // MARK: - Recent Activity
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text("Recent Activity")
                                .font(.headline)
                            Spacer()
                            NavigationLink(destination: Text("All Transactions")) {
                                Text("View all")
                                    .foregroundColor(.blue)
                                    .font(.subheadline)
                            }
                        }
                        .padding(.horizontal)

                        ForEach(recentActivity) { activity in
                            RecentActivityView(transaction: activity)
                        }
                    }

                }
                .padding()
            }
        }
    }
}

// MARK: - Profile Initials View
struct ProfileInitialsView: View {
    let name: String
    
    var body: some View {
        let initial = name.prefix(1).uppercased()
        
        Text(initial)
            .font(.title)
            .fontWeight(.bold)
            .frame(width: 50, height: 50)
            .background(Color.blue.opacity(0.3))
            .clipShape(Circle())
            .foregroundColor(.white)
    }
}

// MARK: - Models
struct SplitBill: Identifiable {
    let id: Int
    let place: String
    let amount: Double
    let people: [String]
}

struct Transaction: Identifiable {
    let id: Int
    let friend: String
    let description: String
    let amount: Double
    let date: String
}

// MARK: - Components
struct RecentSplitBillView: View {
    let split: SplitBill
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(split.place)
                    .font(.headline)
                Spacer()
                Image(systemName: "square.and.arrow.up") // Share icon
            }
            
            HStack {
                Text("Total Bill: ")
                    .font(.subheadline)
                Text("$\(String(format: "%.2f", split.amount))")
                    .font(.subheadline)
                    .bold()
            }
            
            HStack {
                Text("Split with:")
                    .font(.subheadline)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(split.people, id: \.self) { person in
                            Text(person.prefix(1))
                                .font(.footnote)
                                .fontWeight(.medium)
                                .foregroundColor(.white)
                                .frame(width: 28, height: 28)
                                .background(Color.blue.opacity(0.3))
                                .clipShape(Circle())
                        }
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
            }
            
            // ✅ Updated NavigationLink inside the button
            NavigationLink(destination: ContentView()) {
                Text("Split Now")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.2), radius: 5)
    }
}


struct RecentActivityView: View {
    let transaction: Transaction
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("\(transaction.friend) \(transaction.description)")
                    .font(.subheadline)
                Text(transaction.date)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            Spacer()
            Text("$\(String(format: "%.2f", transaction.amount))")
                .font(.headline)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.2), radius: 5)
    }
}

// MARK: - Preview
#Preview {
    HomeView()
}
