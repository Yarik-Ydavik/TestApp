//
//  ContactView.swift
//  TestApp
//
//  Created by Yaroslav Zagumennikov on 16.02.2024.
//

import SwiftUI
import Combine

struct SettingsButton: Identifiable, Hashable  {
    let id = UUID()
    let image : String
    let name : String
    let descroption : String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: SettingsButton, rhs: SettingsButton) -> Bool {
        return lhs.id == rhs.id
    }
}

let DataSettingsButton = [
    SettingsButton(image: "Media", name: "Media, Links, and Docs", descroption: "12"),
    SettingsButton(image: "Starred_Messages", name: "Starred Messages", descroption: "None"),
    SettingsButton(image: "Chat_Search", name: "Chat Search", descroption: ""),
    SettingsButton(image: "Mute", name: "Mute", descroption: "No"),
    SettingsButton(image: "Custom_Tone", name: "Custom Tone", descroption: "Default (Note)"),
    SettingsButton(image: "Save_To_Camera_Roll", name: "Save To Camera Roll", descroption: "Default"),
    SettingsButton(image: "Encryption", name: "Encryption", descroption: "Messages to this chat and calls are secured with end-to-end encryption. Tap to verify."),
]

struct ContactView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    var item : Chats
    
    var body: some View {
        VStack {
            Image("\(item.avatar)_XL")
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .edgesIgnoringSafeArea(.horizontal)

            VStack {
                UserInfoView(item: item)
                
                SettingsSectionView()
            }
        }
        .navigationBarTitle(Text("Contact Info"), displayMode: .inline )
        .toolbar(content: {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: { self.mode.wrappedValue.dismiss() }, label: {
                    HStack (spacing: 2  ) {
                        Image(systemName: "chevron.left")
                            .fontWeight(.bold)
                        Text(item.name.prefix(12))
                            .lineLimit(1)
                            .fontWeight(.light)
                            .font(.headline)
                    }
                })

            }
            
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    EditContact(item: item)
                        .navigationBarBackButtonHidden()
                } label: { Text ("Edit") }

                Button("Edit", action: {})
            }
        })
    }
}

#Preview {
    NavigationStack {
        ContactView(item: Chats(
            avatar: "user3", name: "Martha Craig", numberPhone: "+1 202 555 0181", messageType: .photo("image"), readLastMessage: false, date: "11/16/19", chatHistory: [
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
    
}

extension ContactView {
    struct UserInfoView: View {
        let item: Chats
        var body: some View {
            List{
                ContactInfoView(item: item)
                ContactDescriptionView()
            }
            .listStyle(.plain)
            .scrollDisabled(true)
            .frame(height: 120)
        }
        
        struct ContactInfoView: View {
            let item: Chats
            var body: some View {
                HStack{
                    VStack (alignment: .leading, spacing: 5) {
                        Text(item.name)
                            .font(.title3)
                            .fontWeight(.medium)
                        Text(item.numberPhone)
                            .font(.footnote)
                            .fontWeight(.thin)
                    }
                    Spacer()
                    UserConnectionView()
                }
            }
        }
        
        struct ContactDescriptionView: View {
            var body: some View {
                VStack(alignment: .leading, spacing: 5) {
                    Text("Design adds value faster, than it adds cost")
                        .font(.callout)
                        .fontWeight(.regular)
                    Text("Dec 18, 2018")
                        .font(.footnote)
                        .fontWeight(.thin)
                }
            }
        }
        
        struct UserConnectionView: View {
            var body: some View {
                HStack (spacing: 5){
                    ConnectionButton(image: "message.fill", action: {  })
                    ConnectionButton(image: "video.fill", action: {  })
                    ConnectionButton(image: "phone.fill", action: {  })
                }
            }
        }
        struct ConnectionButton: View {
            let image: String
            let action: () -> Void
            var body: some View {
                Image(systemName: image)
                    .foregroundStyle(.blue)
                    .padding(10)
                    .background(Color(#colorLiteral(red: 0.9285272956, green: 0.9294736981, blue: 0.9995815158, alpha: 1)))
                    .clipShape(Circle())
                    .onTapGesture { action() }
            }
        }
    }
    
    struct SettingsSectionView: View {
        var body: some View {
            List{
                Section() {
                    ForEach(Array(DataSettingsButton.prefix(3)), id: \.self) { item in
                        SettingsButtonItem(item: item)
                    }
                }
                
                Section() {
                    ForEach(Array(DataSettingsButton.dropFirst(3)), id: \.self) { item in
                        SettingsButtonItem(item: item)
                    }
                }
            }
            .listStyle(.grouped)
        }
        
        struct SettingsButtonItem: View {
            let item: SettingsButton
            var body: some View {
                NavigationLink {
                    
                } label: {
                    HStack {
                        Image(item.image)
                            .padding(.trailing, 10)
                        if item.name == "Encryption" {
                            VStack(alignment: .leading, spacing: 5, content: {
                                Text(item.name)
                                Text(item.descroption)
                                    .font(.caption)
                                    .opacity(0.5)
                            })
                        }
                        else {
                            Text(item.name)
                            Spacer()
                            Text(item.descroption)
                                .opacity(0.5)
                        }
                        
                    }
                }
            }
        }
    }
}
