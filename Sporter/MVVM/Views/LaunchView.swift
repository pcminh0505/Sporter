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
                NavigationView {
                    HomeView()
                        .navigationBarHidden(true)
                }
            } else {
                // Load launch/splash view
//                Lottie(name: "rocket", loopMode: .playOnce)
//                    .frame(width: 350, height: 300)

                Text("Splash Screen")
                    .foregroundColor(Color.accentColor).opacity(opacity)
                    .font(.headline)
                    .onAppear {
                    // Adjust in and out opacity animation
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
                        withAnimation {
                            self.opacity = 1.0
                        }
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation {
                            self.opacity = 0.0
                        }
                    }
                }
                    .padding(.bottom, 100)

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
