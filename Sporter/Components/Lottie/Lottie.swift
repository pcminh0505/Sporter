//
//  Lottie.swift
//  Sporter
//
//  Created by Minh Pham on 30/08/2022.
//

import SwiftUI
import Lottie

// LottieView implement Animated Icon retrieved from Lottie JSON in the same folder
struct Lottie: UIViewRepresentable {
    var name: String
    var loopMode: LottieLoopMode
    var animationView = AnimationView()
    
    func makeUIView(context: UIViewRepresentableContext<Lottie>) -> UIView {
        let view = UIView(frame: .zero)
        
        let animation = Animation.named(name)
        animationView.animation = animation
        animationView.animationSpeed = 0.5
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = loopMode
        animationView.play()

        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)
        
        NSLayoutConstraint.activate([
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor),
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])

        return view
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {
    }
}

struct Lottie_Previews: PreviewProvider {
    static var previews: some View {
        Lottie(name: "pirates", loopMode: .playOnce)
    }
}
