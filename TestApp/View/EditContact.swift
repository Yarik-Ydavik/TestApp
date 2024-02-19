//
//  EditContact.swift
//  TestApp
//
//  Created by Yaroslav Zagumennikov on 19.02.2024.
//

import SwiftUI

struct EditContact: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @EnvironmentObject var cvm: ChatViewModel
    @State var Name: String = ""
    @State var SurName: String = ""
    @State var PhoneNumber: String = ""
    @State var selectedCountry:String = "🇺🇸 USA"
        
    var item : Chats
    var body: some View {
        VStack {
            EditFormView(name: $Name, field: "Name", item: item)
            EditFormView(name: $SurName, field: "", item: item)
            EditFormView(name: $selectedCountry, field: "Phone", item: item)
            EditFormView(name: $PhoneNumber, field: "mobile", item: item)
            Divider()
            
            HStack {
                VStack (alignment: .leading, spacing: 30){
                    Button("more fields") {}
                    Button("Delete Contact") {}
                        .foregroundStyle(Color(UIColor.red))
                }
                Spacer()
            }
        }
        .padding(.vertical)
        .frame(maxHeight: .infinity, alignment: .top)
        .padding(.leading)
        .navigationBarTitle(Text("Edit Contact"), displayMode: .inline )
        .toolbar(content: {
            ToolbarItem(placement: .topBarLeading) {
                VStack{
                    Button(action: { self.mode.wrappedValue.dismiss() }, label: {
                        Text("Cancel")
                    })
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    if Name != "" || SurName != "" || PhoneNumber != ""{
                        cvm.saveContact(Name: Name + " " + SurName, item: item)
                    }
                    
                }, label: {
                    Text("Save")
                        .fontWeight(.semibold)
                        .foregroundStyle(Name != "" || SurName != "" ? .black : Color(UIColor.lightGray) )
                })
            }
        })
    }
}

#Preview {
    NavigationStack {
        EditContact(item: Chats(
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
            ])
        )
        .environmentObject(ChatViewModel())
    }
}

extension EditContact {
    struct EditFormView: View {
        let countries = ["🇺🇸 USA", "🇬🇧 UK", "🇫🇷 France", "🇩🇪 Germany", "🇮🇹 Italy", "🇪🇸 Spain", "🇳🇿 New Zealand"]
        @Binding var name: String
        let field: String
        let item: Chats
        var body: some View {
            HStack {
                if field == "Name" || field == "" || field == "mobile" {
                    if field == "mobile" {
                        VStack(alignment: .leading) {
                            HStack (alignment: .bottom, spacing: 5) {
                                Button("mobile") {  }
                                Text(Image(systemName: "chevron.right"))
                                    .font(.subheadline)
                                    .opacity(0.3)
                            }
                        }
                        .frame(width: 100, alignment: .leading)

                    } else {
                        Text(field)
                            .frame(width: 100, alignment: .leading)
                            .padding(.bottom, 10)
                            .fontWeight(.semibold)
                    }
                    
                    VStack {
                        TextField(text: $name) {
                            Text(field != "mobile" ? item.name.components(separatedBy: " ")[ field == "" ? 1 : 0] : item.numberPhone)
                                .foregroundStyle( Color(UIColor.black) )
                        }
                        field != "mobile" ? Divider() : nil
                    }
                } else {
                    Text(field)
                        .frame(width: 100, alignment: .leading)
                        .padding(.bottom, 10)
                        .fontWeight(.semibold)
                    VStack {
                        Menu {
                            ForEach(countries, id: \.self) { country in
                                Button(country) {
                                    name = country
                                }
                            }
                        } label: {
                            HStack{
                                Text(name)
                                Spacer()
                                Text(Image(systemName: "chevron.right"))
                                    .font(.subheadline)
                                    .opacity(0.3)
                                    .padding(.horizontal)
                            }
                        }
                        .menuStyle(.borderlessButton)
                        .foregroundStyle(Color(UIColor.black))
                        Divider()
                    }
                }
            }
            .frame(height: 35)
        }
    }
}


// Другое решение
//            HStack (alignment: .top) {
//                VStack(alignment: .leading, spacing: 16) {
//                    Text("Name")
//                    Divider()
//                    Text("Phone")
//                    Divider()
//                    Spacer().frame(height: 34)
//                    HStack (alignment: .bottom, spacing: 5) {
//                        Button("mobile") {  }
//                        Text(Image(systemName: "chevron.right"))
//                            .font(.subheadline)
//                            .opacity(0.3)
//                    }
//                    Divider()
//                }
//                VStack(alignment: .leading, spacing: 15) {
//                    TextField(text: $Name) {
//                        Text(item.name.components(separatedBy: " ")[0])
//                            .foregroundStyle( Color(UIColor.black) )
//                    }
//                    Divider()
//                    TextField(text: $SurName) {
//                        Text(item.name.components(separatedBy: " ")[1])
//                            .foregroundStyle( Color(UIColor.black) )
//                    }
//                    Divider()
//                    HStack{
//                        Menu {
//                            ForEach(countries, id: \.self) { country in
//                                Button(country) {
//                                    selectedCountry = country
//                                }
//                            }
//                        } label: {
//                            HStack{
//                                Text(selectedCountry)
//                                Spacer()
//                                Text(Image(systemName: "chevron.right"))
//                                    .font(.subheadline)
//                                    .opacity(0.3)
//                                    .padding(.horizontal)
//                            }
//                        }
//                        .menuStyle(.borderlessButton)
//                        .foregroundStyle(Color(UIColor.black))
//
//                    }
//                    Divider()
//                    TextField(text: $SurName) {
//                        Text(item.name.components(separatedBy: " ")[0])
//                            .foregroundStyle( Color(UIColor.black) )
//                    }
//                    Divider()
//                }
//            }

