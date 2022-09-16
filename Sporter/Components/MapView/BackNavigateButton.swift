//
//  BackNavigateButton.swift
//  Sporter
//
//  Created by Khang on 10/09/2022.
//

import Foundation
import SwiftUI

struct BackNavigateButton : View {
    var body: some View {
        ZStack {
            Image(systemName: "square.fill")
                .resizable()
                .foregroundColor(Color.accentColor)
                .scaledToFit()
                .frame(width: 40, height: 40)
            Image(systemName: "chevron.left")
                .resizable()
                .foregroundColor(.white)
                .scaledToFit()
                .frame(width: 20, height: 20)
        }
    }
}

struct BackNavigateButton_Previews: PreviewProvider {
    static var previews: some View {
        BackNavigateButton()
    }
}
