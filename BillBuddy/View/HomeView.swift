import SwiftUI
import FirebaseAuth

struct HomeView: View {
    @StateObject private var store = FriendStore()
    @State private var userName: String = Auth.auth().currentUser?.displayName ?? ""
    let balance: Double = 50.00

    let recentItems: [ReceiptItem] = [
            ReceiptItem(name: "Katsuretsu",  price: 43.27, assignedFriends: ["Michelle Marcelline", "Callista"]),
            ReceiptItem(name: "Little Rouge", price: 23.50, assignedFriends: ["Kendall", "Whissely Wijaya"])
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
                    .onAppear {
                        if let user = Auth.auth().currentUser {
                          // prefer displayName, else use email before “@”
                          if let name = user.displayName, !name.isEmpty {
                            userName = name
                          } else if let email = user.email {
                            userName = email.components(separatedBy: "@").first ?? "User"
                          }
                        }
                      }
                    
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

                        ForEach(recentItems) { item in
                            RecentSplitBillView(item: item)
                                .environmentObject(store)
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


// MARK: - Preview
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(FriendStore())
    }
}
