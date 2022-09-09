//
//  CustomMapAnnotationView.swift
//  Sporter
//
//  Created by Khang on 07/09/2022.
//

import Foundation
import SwiftUI

struct CustomMapAnnotationView : View {
    @Environment(\.colorScheme) var colorScheme
//    let accentColor =
    let name: String
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack() {
                Image(systemName: "circle.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.pink)
                    .frame(width: 25, height: 25)
                
                Image("dumbbell_white")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 30)
                    .font(.headline)
            }
            Text(name)
                .font(.system(size: 12))
                .foregroundColor(colorScheme == .dark ? .white : .black)
                .glowBorder(color: colorScheme == .dark ? .black : .white, lineWidth: 4)
        }
    }
}

struct CustomeMapAnnotationView_Previews : PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            CustomMapAnnotationView(name: "Phong Gym Nguyen Bao Khang")
        }
    }
}
