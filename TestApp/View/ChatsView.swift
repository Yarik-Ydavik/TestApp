//
//  ChatsView.swift
//  TestApp
//
//  Created by Yaroslav Zagumennikov on 16.02.2024.
//

import SwiftUI

struct ChatsView: View {
    @EnvironmentObject var chatVM : ChatViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                ActionsChats()
                
                ListChats()
            }
            .navigationBarTitle(Text("Chats"), displayMode: .inline )
            .toolbar(content: {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Edit") {}
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {} label: { Image(systemName: "square.and.pencil")}
                }
            })
        }
    }
}

#Preview {
    TabView{
        NavigationStack{
            ChatsView()
        }
        .tabItem {
            HStack{
                Image("Chats")
                    .renderingMode(.template)
                    .foregroundStyle(.black)
                Text("Chats")
            }
        }
    }
}
extension ChatsView {
    // Действия со списком чатов
    struct ActionsChats: View {
        var body: some View {
            HStack {
                Button(action: {}, label: {
                    Text("Broadcast Lists")
                })
                Spacer()
                Button(action: {}, label: {
                    Text("New Group")
                })
            }
            .padding()
        }
    }
    
    // List Chats
    struct ListChats: View {
        @EnvironmentObject var chatVM : ChatViewModel
        var body: some View {
            List(chatVM.chatList.indices, id : \.self ) { index in
                let item = chatVM.chatList[index]
                Chat(item: item)
            }
            .listStyle(.plain)
        }
    }
    
    // Чат
    struct Chat: View {
        let item : Chats
        @EnvironmentObject var chatVM : ChatViewModel
        var body: some View {
            NavigationLink {
                ChatUserView(item: item)
                    .environmentObject(chatVM)
                    .navigationBarHidden(true)
                    .toolbar(.hidden, for: .tabBar)
            } label: {
                ChatInfo(item: item)
            }
            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                SwipeActionsButton(
                    image: "Archive",
                    tint: Color(#colorLiteral(red: 0.2407291234, green: 0.4364325106, blue: 0.6559013128, alpha: 1)),
                    action: {}
                )
                
                SwipeActionsButton( image: "More", tint: nil, action: {} )
            }
        }
    }
    
    // ChatInfo - информация о чате с пользователем
    struct ChatInfo: View {
        let item : Chats
        var body: some View {
            HStack{
                Image(item.avatar)
                    .resizable()
                    .frame(width: 52, height: 52)
                
                VStack (alignment: .leading, spacing: 10){
                    HStack {
                        Text(item.name)
                            .fontWeight(.semibold)
                        
                        Spacer()
                        
                        Text(item.date)
                            .font(.callout)
                            .opacity(0.5)
                    }
                    
                    LastMessage(item: item)
                    
                    
                }
            }
        }
    }
    
    // Last Message info
    struct LastMessage: View {
        let item : Chats
        var body: some View {
            HStack (spacing: 5){
                if item.readLastMessage {
                    Image("Read")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 20, height: 10)
                }
                
                switch item.messageType {
                case .text(let text):
                    TextMessage(text: text)
                case .audio(let audio):
                    AudioMessage(audio: audio)
                case .photo(let photo):
                    PhotoMessage(photo: photo)
                }
            }
        }
    }
    
    // Text message
    struct TextMessage: View {
        let text: String
        var body: some View {
            Text(text)
                .opacity(0.5)
        }
    }
    
    // Audio message
    struct AudioMessage: View {
        let audio: String
        var body: some View {
            HStack (alignment: .center, spacing: 2){
                Image(systemName: "mic.fill")
                    .foregroundStyle(.green)
                Text("\(audio)")
                    .opacity(0.5)
            }
        }
    }
    
    // Photo message
    struct PhotoMessage: View {
        let photo: String
        var body: some View {
            HStack (alignment: .center, spacing: 2){
                Image(systemName: "camera.fill")
                Text("Photo")
            }
            .opacity(0.5)
        }
    }
    
    // SwipeActionsButton
    struct SwipeActionsButton: View {
        let image : String
        let tint : Color?
        let action : () -> Void
        var body: some View {
            Button {
                action()
            } label: {
                Image(image)
            }
            .tint(tint)
        }
    }
}
