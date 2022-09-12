//
//  SquareButton.swift
//  Sporter
//
//  Created by Minh Pham on 12/09/2022.
//

import SwiftUI

struct SquareButton: View {
    let imgName: String
    
    var body: some View {
        ZStack {
            Image(systemName: "square.fill")
                .resizable()
                .foregroundColor(Color.theme.red)
                .scaledToFit()
                .frame(width: 40, height: 40)
            Image(systemName: imgName)
                .resizable()
                .foregroundColor(.white)
                .scaledToFit()
                .frame(width: 20, height: 20)
        }
    }
}

struct SquareButton_Previews: PreviewProvider {
    static var previews: some View {
        SquareButton(imgName: "person.fill")
    }
}
