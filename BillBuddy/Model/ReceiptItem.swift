//
//  ReceiptItem.swift
//  BillBuddy
//
//  Created by Callista Cleine on 24/4/2025.
//

import SwiftUI
import VisionKit

struct ReceiptItem: Identifiable {
    var id = UUID()
    var name: String
    var price: Double
    var quantity: Int = 1
    var assignedFriends: [String] = []
}
