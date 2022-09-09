//
//  LaunchView.swift
//  Sporter
//
//  Created by Minh Pham on 31/08/2022.
//

import SwiftUI
import Lottie

struct LaunchView: View {
    @State var isActive: Bool = false
    @State var opacity = 0.0

    var body: some View {
        VStack {
            if self.isActive {
                // Load main view
                CheckView()
            } else {
                // Load launch/splash view
                Lottie(name: "sporter", loopMode: .playOnce)
                    .frame(width: 350, height: 300)
                    .padding(.top, -UIScreen.main.bounds.height * 0.15)

                VStack (alignment: .center, spacing: 15) {
                    Text("Sporter!")
                        .font(.title2)
                        .foregroundColor(Color.accentColor)
                        .bold()
                    Text("Connecting Sports Players and Gymmers")
                        .font(.headline)
                        .foregroundColor(Color.theme.darkGray)
                }
                    .opacity(opacity)
                    .onAppear {
                    // Adjust in and out opacity animation
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
                        withAnimation {
                            self.opacity = 1.0
                        }
                    }
                }
                    .padding(.top, 20)

            }
        }
        
            .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                withAnimation {
                    self.opacity = 0.0
                    self.isActive = true
                }
            }
        }
    }
}

struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView()
    }
}
