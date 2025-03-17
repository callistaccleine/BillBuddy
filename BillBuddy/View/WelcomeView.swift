//
//  WelcomeView 2.swift
//  BillBuddy
//
//  Created by Callista Cleine on 11/3/2025.
//


import SwiftUI

struct WelcomeView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                // Illustration Image
                Image(systemName: "doc.text.magnifyingglass") // Replace with your custom image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .foregroundColor(.blue)
                
                // Title Text
                Text("Best Way To Split Your Bill Easily")
                    .font(.system(size: 26, weight: .bold))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                
                // Subtitle Text
                Text("Split your bill and your friends easily just by scanning your bill.")
                    .font(.system(size: 16))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)
                
                // Next Button
                NavigationLink(destination: ContentView()) {
                    HStack {
                        Spacer()
                        Text("Get Started")
                            .font(.headline)
                            .foregroundColor(.white)
                        Image(systemName: "arrow.right")
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
                    .frame(width: 200)
                }
                .padding(.top, 20)
                
                Spacer()
            }
            .padding(.top, 50)
        }
    }
}

// Preview
#Preview {
    WelcomeView()
}
