//
//  Chats.swift
//  TestApp
//
//  Created by Yaroslav Zagumennikov on 17.02.2024.
//

import Foundation

struct Chats : Identifiable {
    var id = UUID()
    var avatar: String
    var name: String
    var numberPhone: String
    var messageType: MessageType
    var readLastMessage: Bool
    var date: String
    var chatHistory : [Message]
}
