//
//  ChatViewModel.swift
//  TestApp
//
//  Created by Yaroslav Zagumennikov on 17.02.2024.
//

import Foundation
import Combine

class ChatViewModel: ObservableObject{
    let didChange = PassthroughSubject<ChatViewModel, Never>()
    @Published var chatList: [Chats] = [] {
        didSet {
            didChange.send(self)
        }
    }
    
    init () {
        chatList = [
            Chats(avatar: "user", name: "Andrew Parker", numberPhone: "+1 202 555 0181", messageType: .text("What kind of strategy is better?"), readLastMessage: true, date: "11/16/19", chatHistory: []),
            Chats(avatar: "user1", name: "Karen Castillo", numberPhone: "+1 202 555 0181", messageType: .audio("0:14"), readLastMessage: false, date: "11/16/19", chatHistory: []),
            Chats(avatar: "user2", name: "Maximillian Jacobson", numberPhone: "+1 202 555 0181", messageType: .text("Bro, I have a good idea!"), readLastMessage: true, date: "11/16/19", chatHistory: []),
            Chats(avatar: "user3", name: "Martha Craig", numberPhone: "+1 202 555 0181", messageType: .photo("image"), readLastMessage: false, date: "11/16/19", chatHistory: [
                Message(sender: "Author", date: Date(), message: .text("Good bye!")),
                Message(sender: "Author", date: Date(), message: .text("Good morning!")),
                Message(sender: "Author", date: Date(), message: .text("Japan looks amazing!")),
                Message(sender: "Author", date: Date(), message: .photo("IMG_0475")),
                Message(sender: "Author", date: Date(), message: .photo("IMG_0481")),
                Message(sender: "Maria Craig", date: Date(), message: .text("Do you know what time is it?")),
                Message(sender: "Author", date: Date(), message: .text("It’s morning in Tokyo😎")),
                Message(sender: "Maria Craig", date: Date(), message: .text("What is the most popular meal in Japan?")),
                Message(sender: "Maria Craig", date: Date(), message: .text("Do you like it?")),
                Message(sender: "Author", date: Date(), message: .text("I think top two are:")),
                Message(sender: "Author", date: Date(), message: .photo("IMG_0483")),
                Message(sender: "Author", date: Date(), message: .photo("IMG_0484")),
            ]),
            Chats(avatar: "user4", name: "Tabitha Potter", numberPhone: "+1 202 555 0181", messageType: .text("Actually I wanted to What kind of strategy is better?"), readLastMessage: false, date: "11/16/19", chatHistory: [])
        ]
    }
    
    func sendMessage (
        item : Chats,
        text : String
    ) {
        chatList[ chatList.firstIndex(where: { $0.id == item.id })! ].chatHistory.append(Message(sender: "Author", date: Date(), message: .text(text)))
    }
    
    func saveContact(
        Name: String,
        item : Chats
    ) {
        chatList[ chatList.firstIndex(where: { $0.id == item.id })! ].name = Name
    }
    
}
