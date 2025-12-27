//
//  Message.swift
//  AIChatbot
//
//  Created by Suraj Sharma on 26/12/25.
//

import Foundation

enum Sender {
    case user
    case bot
    case isTyping
}

struct Message: Identifiable {
    let id = UUID()
    var text: String
    let sender: Sender
    var isTyping: Bool
}
