//
//  ProfileInitialsView.swift
//  BillBuddy
//
//  Created by Callista Cleine on 14/6/2025.
//
import SwiftUI

struct ProfileInitialsView: View {
    let name: String
    
    var body: some View {
        let initial = name.prefix(1).uppercased()
        
        Text(initial)
            .font(.caption)
            .fontWeight(.bold)
            .frame(width: 20, height: 20)
            .background(Color.blue.opacity(0.3))
            .clipShape(Circle())
            .foregroundColor(.white)
    }
}

