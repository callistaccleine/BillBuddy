//
//  Friend.swift
//  BillBuddy
//
//  Created by Callista Cleine on 12/6/2025.
//
import SwiftUI
import VisionKit

struct Friend: Identifiable, Hashable {
    let id: UUID
    let name: String
    let username: String
    let avatarURL: URL?    // or an Image name
}
