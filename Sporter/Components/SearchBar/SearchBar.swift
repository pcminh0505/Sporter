//
//  SearchBar.swift
//  Sporter
//
//  Created by Minh Pham on 17/09/2022.
//

import SwiftUI

struct SearchBar: View {
    @Binding var searchText: String
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(searchText.isEmpty ? Color(uiColor: .systemGray4) : Color.accentColor)

            TextField("Search...", text: $searchText)
                .foregroundColor(Color.theme.textColor)
                .overlay(
                Image(systemName: "xmark.circle.fill")
                    .padding()
                    .offset(x: 10)
                    .foregroundColor(Color.accentColor)
                    .opacity(searchText.isEmpty ? 0.0 : 1.0)
                    .onTapGesture {
                    searchText = ""
                }
                , alignment: .trailing
            )
        }
            .font(.headline)
            .padding(15)
            .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(uiColor: .systemGray5))
                .shadow(color: Color.accentColor.opacity(0.15), radius: 10, x: 0, y: 0)
        )
    }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SearchBar(searchText: .constant("Search for friends"))
            SearchBar(searchText: .constant("Search for friends"))
                .preferredColorScheme(.dark)
        }
    }
}
