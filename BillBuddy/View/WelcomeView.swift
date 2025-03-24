//
//  WelcomeView.swift
//  BillBuddy
//
//  Created by Callista Cleine on 11/3/2025.
//

import SwiftUI

struct WelcomeView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Spacer()
                
                // Custom Welcome Illustration
                Image("welcome_image")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 350, height: 350)
                    .padding(.top, 20)
                
                // Title Text
                Text("Best Way to Split Your Bill Easily")
                    .font(.system(size: 26, weight: .bold))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)
                    .padding(.horizontal, 20)
                
                // Subtitle Text
                Text("Split your bill and your friends easily just by scanning your bill")
                    .font(.system(size: 16))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)
                
                // Page Indicator Dots
                HStack(spacing: 6) {
                    Circle().fill(Color.blue).frame(width: 8, height: 8)
                    Circle().fill(Color.gray.opacity(0.5)).frame(width: 8, height: 8)
                    Circle().fill(Color.gray.opacity(0.5)).frame(width: 8, height: 8)
                }
                .padding(.top, 10)

                // Get Started Button
                NavigationLink(destination: ContentView()) {
                    HStack {
                        Spacer()
                        Text("Get Started")
                            .font(.headline)
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(12)
                    .frame(width: 200, height: 50)
                }
                .padding(.top, 10)

                Spacer()
            }
            .padding(.bottom, 50)
        }
    }
}

#Preview {
    WelcomeView()
}
