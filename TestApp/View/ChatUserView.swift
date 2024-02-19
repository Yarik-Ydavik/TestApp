//
//  ChatUserView.swift
//  TestApp
//
//  Created by Yaroslav Zagumennikov on 16.02.2024.
//

import SwiftUI

struct ChatUserView: View {
    @EnvironmentObject var chatVM : ChatViewModel
    let item: Chats
    var body: some View {
        NavigationStack {
            VStack {
                TopBar(user: item)
                ChatList(chatHistory: item.chatHistory)
                BottomBar(item: item)
            }
            .background {
                Image("chats_background")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea(.all)
            }
        }
    }
}

#Preview {
    ChatUserView(item: Chats(avatar: "user3", name: "Martha Craig", numberPhone: "+1 202 555 0181", messageType: .photo("image"), readLastMessage: false, date: "11/16/19", chatHistory: [
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
    ]))
}

extension ChatUserView {
    struct TopBar:  View {
        @Environment(\.presentationMode) var mode: Binding<PresentationMode>
        var user: Chats
        var body: some View {
            HStack {
                ButtonTopBar(image: "chevron.left", action: { self.mode.wrappedValue.dismiss() })
                    .fontWeight(.semibold)
                
                Spacer()
                
                UserInfo(user: user)
                
                Spacer()
                
                ButtonTopBar(image: "video", action: {})
                ButtonTopBar(image: "phone", action: {})
            }
            .frame(height: 40)
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(10)
            .background(Color(UIColor.secondarySystemBackground))
        }
        
        struct UserInfo: View {
            var user: Chats
            var body: some View {
                HStack{
                    Image(user.avatar)
                        .resizable()
                        .scaledToFit()
                    NavigationLink {
                        ContactView(item: user)
                            .navigationBarBackButtonHidden(true)
                    } label: {
                        VStack (alignment: .leading) {
                            Text(user.name)
                                .font(.title3)
                                .fontWeight(.semibold)

                            Text("tap here for contact info")
                                .font(.caption2)
                                .opacity(0.5)
                        }
                    }

                    
                }
                .foregroundStyle(.black)
            }
        }
        
        struct ButtonTopBar: View {
            let image: String
            let action: () -> Void
            var body: some View {
                Button(action: { action() }, label: {
                    Image(systemName: image)
                        .font(.title2)
                        .fontWeight(.light)
                })
            }
        }
        
    }
    
    struct ChatList: View {
        var chatHistory: [Message]
        var body: some View {
            ScrollView {
                ScrollViewReader { value in
                    LazyVStack (spacing: 3) {
                        ForEach(chatHistory.indices, id: \.self) { index in
                            let sender = chatHistory[index].sender
                            let nextSender = chatHistory[index == chatHistory.count - 1 ? index : index + 1].sender
                            
                            HStack {
                                HStack {
                                    switch chatHistory[index].message {
                                    case .text(let text):
                                        TextMessage( text: text, sender: sender, date: chatHistory[index].date )
                                        
                                    case .audio(let audio):
                                        AudioMessage(audio: audio)
                                        
                                    case .photo(let photo):
                                        PhotoMessage(photo: photo, date: chatHistory[index].date)
                                    }
                                }
                                .background {
                                    BackGroundMessage(
                                        sender: sender,
                                        nextSender: nextSender,
                                        chatHistory: chatHistory,
                                        index: index
                                    )
                                }
                                .frame(maxWidth: 280, alignment: sender == "Author" ? Alignment.trailing : Alignment.leading)
                                .padding(.horizontal)
                            }
                            .frame(maxWidth: .infinity, alignment: sender == "Author" ? Alignment.trailing : Alignment.leading)
                            .id(chatHistory[index].id)
                        }
                        .id(chatHistory.count)
                    }
                    .onAppear {
                        withAnimation{
                            if !chatHistory.isEmpty {
                                value.scrollTo(chatHistory.last!.id)
                            }
                        }
                    }
                    .onChange(of: chatHistory.count) { _ in
                        withAnimation{
                            value.scrollTo(chatHistory.count)
                        }
                    }
                }
            }
            .scrollIndicators(.hidden)
        }
        
        struct TextMessage: View {
            let text : String
            let sender : String
            let date : Date
            var body: some View {
                Text(text)
                    .messageView(sender: sender, date: date, text: text)
            }
        }

        struct AudioMessage: View {
            let audio : String
            var body: some View {
                Text("Audio: \(audio)")
            }
        }

        struct PhotoMessage: View {
            let photo : String
            let date: Date
            var body: some View {
                VStack {
                    HStack {
                        Image("File_Icon")
                        Text("\(photo)")
                    }
                    .fontWeight(.light)
                    .padding(8)
                    .frame(maxWidth: .infinity, alignment: Alignment.leading)
                    .background(Color(#colorLiteral(red: 0.8156155944, green: 0.9094735384, blue: 0.7420162559, alpha: 1)))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    
                    HStack {
                        Text("2.8 MB · png")
                        Spacer()
                        Text(date, style: .time )
                    }
                    .padding(.horizontal, 5)
                    .fontWeight(.light)
                    .opacity(0.5)
                    .font(.caption2)
                }
                .frame(maxWidth: 150)
                .padding(3)
            }
        }
        
        struct BackGroundMessage: View {
            let sender: String
            let nextSender: String
            let chatHistory: [Message]
            let index: Int
            var body: some View {
                Rectangle()
                    .fill( sender == "Author" ? Color(#colorLiteral(red: 0.8612554669, green: 0.9672409892, blue: 0.7705629468, alpha: 1)) : Color.white)
                    .shadow(color: Color(UIColor.lightGray) , radius: CGFloat(0.1), y: 1)
                    .clipShape(
                        //                        
//                        Text((chatHistory.count - 1).description)
//                        Text(index.description)
                        
                        sender == nextSender ?
                        .rect(cornerRadii: RectangleCornerRadii(
                            topLeading: 10,
                            bottomLeading: 10,
                            bottomTrailing: 10,
                            topTrailing: 10
                        ))
                        :
                        .rect(cornerRadii: RectangleCornerRadii(
                            topLeading: 10,
                            bottomLeading: sender == "Author"  ? 10 : 0,
                            bottomTrailing: sender == "Author" ? 0 : 10,
                            topTrailing: 10
                        ))
                        
                        
                        
                        
                    )
            }
        }
    }
    
    struct BottomBar: View {
        @EnvironmentObject var chatVM : ChatViewModel
        let item: Chats
        @State var text: String = ""
        var body: some View {
            HStack (alignment: .center, spacing: 10) {
                ButtonBottomBar(image: "plus", action: {})
                    .fontWeight(.regular)
                
                TextField(text: $text) { }
                .padding(6)
                .padding(.horizontal, 5)
                .background(RoundedRectangle(cornerRadius: 20).stroke(Color.gray, lineWidth: 0.4))
                .overlay(alignment: .trailing, content: {
                    if text == "" {
                        ButtonBottomBar(image: "square.split.bottomrightquarter", action: {})
                        .padding(5)
                    }
                })

                ButtonBottomBar(image: "camera", action: {})

                if text == "" {
                    ButtonBottomBar(image: "mic", action: {})
                } else {
                    ButtonBottomBar(image: "paperplane.fill", action: {
                        chatVM.sendMessage( item: item, text: text )
                        text = ""
                    })
                }
                
            }
            .frame(height: 40)
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(10)
            .background(Color(UIColor.secondarySystemBackground))
        }
        struct ButtonBottomBar: View {
            let image: String
            let action: () -> Void
            var body: some View {
                Button(action: { action() }, label: {
                    Image(systemName: image)
                        .font(.title2)
                        .fontWeight(.light)
                })
            }
        }
    }
}

extension Text {
    // Функция, которая позволяет информации о сообщении стать обтекаемой для текста сообщения
    func messageView(sender: String, date: Date, text: String) -> some View {
        if text.count < 25 {
            return AnyView( 
                HStack {
                    self
                    MessageInfo(sender: sender, date: date, text: text)
                }
                .padding(8)
            )
        } else {
            return AnyView(
                VStack(alignment: .trailing) {
                    self
                    MessageInfo(sender: sender, date: date, text: text)
                }
                .padding(8)
            )
        }
    }
}

struct MessageInfo: View {
    let sender : String
    let date: Date
    let text: String
    var body: some View {
        HStack (spacing: 2){
            Text(date, style: .time )
                .fontWeight(.light)
                .opacity(0.5)
                .font(.caption2)
                .offset(y: text.count < 25 ? 10 : 0)
            
            if sender == "Author" {
                Image("Read")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 10)
                    .offset(y: text.count < 25 ? 10 : 0)
            }
        }
    }
}
