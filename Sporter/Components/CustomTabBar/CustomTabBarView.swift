//
//  CustomTabBarView.swift
//  Sporter
//
//  Created by Minh Pham on 09/09/2022.
//

import SwiftUI

struct CustomTabBarView: View {

    let tabs: [TabBarItem]
    @Binding var selection: TabBarItem
    @Namespace private var namespace
    @State var localSelection: TabBarItem

    var body: some View {
        tabBar
            .onChange(of: selection, perform: { value in
            withAnimation(.easeInOut) {
                localSelection = value
            }
        })
    }
}

struct CustomTabBarView_Previews: PreviewProvider {

    static let tabs: [TabBarItem] = [
            .home, .discover, .profile
    ]

    static var previews: some View {
        VStack {
            Spacer()
            CustomTabBarView(tabs: tabs, selection: .constant(tabs.first!), localSelection: tabs.first!)
        }
    }
}

extension CustomTabBarView {

    private func tabView(tab: TabBarItem) -> some View {
        VStack {
            Image(systemName: tab.iconName)
                .font(.subheadline)
            Text(tab.title)
                .font(.system(size: 10, weight: .semibold, design: .rounded))
        }
            .foregroundColor(localSelection == tab ? tab.color : Color.gray)
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity)
            .background(
            ZStack {
                if localSelection == tab {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(tab.color.opacity(0.2))
                        .matchedGeometryEffect(id: "background_rectangle", in: namespace)
                }
            }
        )
    }

    private var tabBar: some View {
        HStack {
            ForEach(tabs, id: \.self) { tab in
                tabView(tab: tab)
                    .onTapGesture {
                    switchToTab(tab: tab)
                }
            }
        }
            .padding(6)
            .background(Color(uiColor: .systemGray5).ignoresSafeArea(edges: .bottom))
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 5)
            .padding(.horizontal)
    }

    private func switchToTab(tab: TabBarItem) {
        selection = tab
    }

}
