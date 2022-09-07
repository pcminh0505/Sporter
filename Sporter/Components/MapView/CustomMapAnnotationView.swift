//
//  CustomMapAnnotationView.swift
//  Sporter
//
//  Created by Khang on 07/09/2022.
//

import Foundation
import SwiftUI

struct CustomMapAnnotationView : View {
//    let accentColor =
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack() {
                Image(systemName: "circle.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.pink)
                    .frame(width: 35, height: 35)
                
                Image("dumbbell_white")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .font(.headline)
            }
            
            Image(systemName: "triangle.fill")
                .resizable()
                .scaledToFit()
                .foregroundColor(.pink)
                .frame(width: 10, height: 10)
                .rotationEffect(Angle(degrees: 180))
                .offset(y: -3)
                .padding(.bottom, 40)
        }
    }
}

struct CustomeMapAnnotationView_Previews : PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            CustomMapAnnotationView()
        }
    }
}
