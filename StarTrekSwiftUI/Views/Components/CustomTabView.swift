//
//  CustomTabView.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 5/22/25.
//

import SwiftUI

public struct CustomTabView: View {
    let COLOR_SELECTED = Color("Aqua")
    let COLOR_UNSELECTED = Color.white
    private let titles: [String]
    private let icons: [String]
    private let tabViews: [AnyView]

@State private var selection = 0
@State private var indexHovered = -1

public init(content: [(title: String, icon: String, view: AnyView)]) {
    self.titles = content.map{ $0.title }
    self.icons = content.map{ $0.icon }
    self.tabViews = content.map{ $0.view }
}

public var tabBar: some View {
    HStack {
        Spacer()
        ForEach(0..<titles.count, id: \.self) { index in

            VStack {
                Image(self.icons[index])
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    //.font(.largeTitle)
                Text(self.titles[index])
                    .font(.system(size:12))
            }
            .frame(height: 80)
            .background(Color.gray.opacity(((self.selection == index) || (self.indexHovered == index)) ? 0.3 : 0),
                        in: RoundedRectangle(cornerRadius: 8, style: .continuous))

           // .frame(height: 80)
            .padding(.horizontal, 0)
            .foregroundColor(self.selection == index ? COLOR_SELECTED : COLOR_UNSELECTED)
            .onHover(perform: { hovering in
                if hovering {
                    indexHovered = index
                } else {
                    indexHovered = -1
                }
            })
            .onTapGesture {
                self.selection = index
            }
        }
        Spacer()
    }
  //  .padding(0)
    .background(Color(.windowBackgroundColor))
}

public var body: some View {
    VStack(spacing: 0) {
        tabBar

        tabViews[selection]
            .padding(0)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
       // .padding(0)
    }
}


