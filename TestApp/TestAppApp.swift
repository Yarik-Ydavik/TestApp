//
//  TestAppApp.swift
//  TestApp
//
//  Created by Yaroslav Zagumennikov on 16.02.2024.
//

import SwiftUI

@main
struct TestAppApp: App {
    var body: some Scene {
        WindowGroup {
            @StateObject var chatVM = ChatViewModel()
            
            TabView{
                Color.white
                    .tabItem { TabItem(title: "Status", icon: "Status") }
                
                Color.white
                    .tabItem { TabItem(title: "Calls", icon: "Calls") }

                Color.white
                    .tabItem { TabItem(title: "Camera", icon: "Camera") }
                
                ChatsView()
                    .environmentObject(chatVM)
                    .tabItem { TabItem(title: "Chats", icon: "Chats") }
                
                Color.white
                    .tabItem { TabItem(title: "Settings", icon: "Settings") }
            }
        }
    }
}
