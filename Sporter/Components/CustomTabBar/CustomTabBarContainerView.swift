//
//  TabBarItem.swift
//  Sporter
//
//  Created by Minh Pham on 09/09/2022.
//

import SwiftUI

struct CustomTabBarContainerView<Content:View>: View {

    @Binding var selection: TabBarItem
    let content: Content
    @State private var tabs: [TabBarItem] = []

    init(selection: Binding<TabBarItem>, @ViewBuilder content: () -> Content) {
        self._selection = selection
        self.content = content()
    }

    var body: some View {
        VStack {
            content

            Spacer()

            CustomTabBarView(tabs: tabs, selection: $selection, localSelection: selection)
                .padding(.bottom, 25)
        }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .edgesIgnoringSafeArea(.bottom)
            .navigationBarHidden(true)
            .onPreferenceChange(TabBarItemsPreferenceKey.self, perform: { value in
            self.tabs = value
        })
    }
}

struct CustomTabBarContainerView_Previews: PreviewProvider {
    static let tabs: [TabBarItem] = [
            .home, .discover, .profile
    ]

    static var previews: some View {
        CustomTabBarContainerView(selection: .constant(tabs.first!)) {
            Color.accentColor
        }
    }
}
