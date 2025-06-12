import SwiftUI

struct HomeView: View {
    @StateObject private var store = FriendStore()
    // Sample User Data
    @AppStorage("currentUserName") private var userName: String = "User"
    let balance: Double = 50.00

    let recentSplits: [SplitBill] = [
        SplitBill(id: 1, place: "Katsuretsu", amount: 43.27, people: ["Alex", "Emma", "John", "Sophia"]),
        SplitBill(id: 2, place: "Little Rouge", amount: 23.50, people: ["Mike", "Eleanor"])
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    
                    // MARK: - Header (User Profile + Greeting)
                    HStack {
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
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Your Balance")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                Text("$\(String(format: "%.2f", balance))")
                                    .font(.system(size: 25, weight: .bold))
                                    .foregroundColor(.white)
                            }
                            Spacer()
                            Button(action: {
                                print("Top Up tapped")
                            }) {
                                HStack {
                                    Image(systemName: "plus")
                                    Text("Top Up")
                                }
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color.gray.opacity(0.3))
                                .foregroundColor(.white)
                                .cornerRadius(20)
                            }
                        }
                        .padding()
                        .frame(width: 350, height: 100)
                        .background(Color.blue)
                        .cornerRadius(15)
                    }
                    .padding(.horizontal)

                    
                    // MARK: - Quick Action Buttons
                    HStack(spacing: 30) {
                        QuickActionButton(icon: "arrow.left.arrow.right", label: "Transfer", destination: AnyView(FriendListView().environmentObject(store)))
                        QuickActionButton(icon: "arrow.clockwise", label: "Request", destination: AnyView(FriendListView().environmentObject(store)))
                        QuickActionButton(icon: "doc.text", label: "Split Bill", destination: AnyView(ScanView()))
                        QuickActionButton(icon: "person.badge.plus", label: "Invite", destination: AnyView(InviteView()))
                    }
                    .padding(.top, 10)

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
                    .padding(.bottom)
                } // Close VStack
            } // Close ScrollView
        } // Close NavigationStack
    }
}

// MARK: - Quick Action Button Component
struct QuickActionButton: View {
    let icon: String
    let label: String
    let destination: AnyView

    var body: some View {
        VStack {
            NavigationLink(destination: destination) {
                Image(systemName: icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .padding()
                    .background(Color.white)
                    .clipShape(Circle())
                    .shadow(radius: 3)
            }
            Text(label)
                .font(.caption)
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


// MARK: - Preview
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(FriendStore())
    }
}
