//
//  TabItem.swift
//  TestApp
//
//  Created by Yaroslav Zagumennikov on 18.02.2024.
//

import SwiftUI



struct TabItem: View {
    let title: String
    let icon: String
    var body: some View {
        Label(
            title: { Text(title) },
            icon: { Image(uiImage: UIImage(named: icon)!).renderingMode(.template) }
        )
    }
}

#Preview {
    TabItem( title: "Settings", icon: "Settings")
        .labelStyle(TabBarLabelStyle())
}

// For Preview
struct TabBarLabelStyle: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        VStack {
            configuration.icon
            configuration.title
        }
    }
}
