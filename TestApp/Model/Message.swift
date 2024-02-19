//
//  Message.swift
//  TestApp
//
//  Created by Yaroslav Zagumennikov on 17.02.2024.
//

import Foundation

struct Message : Identifiable, Equatable {
    static func == (lhs: Message, rhs: Message) -> Bool {
        return lhs.sender == rhs.sender &&
               lhs.date == rhs.date &&
               lhs.message == rhs.message
    }
    
    let id = UUID()
    let sender : String
    let date : Date
    let message : MessageType
}

enum MessageType : Equatable {
    case text(String)
    case audio(String)
    case photo(String)
}
