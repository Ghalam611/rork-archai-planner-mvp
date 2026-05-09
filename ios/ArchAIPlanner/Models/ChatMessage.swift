//
//  ChatMessage.swift
//  ArchAIPlanner
//
//  Created by Rork on May 8, 2026.
//

import Foundation

struct ChatBubbleMessage: Identifiable, Hashable {
    enum Role { case user, ai }
    let id: UUID = UUID()
    let role: Role
    let text: String
}
