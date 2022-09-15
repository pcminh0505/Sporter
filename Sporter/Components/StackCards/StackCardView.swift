//
//  StackCardView.swift
//  TinderUI
//
//  Created by Long Tran on 04/09/2022.
//

import Foundation
import SwiftUI

struct StackCardView: View {
    @EnvironmentObject var discoveryVM: DiscoveryViewModel
    
    var user: User
    
    // Gesture Properties
    let defaultImageURL: String = "https://t4.ftcdn.net/jpg/00/64/67/63/360_F_64676383_LdbmhiNM6Ypzb3FM4PPuFP9rHe7ri8Ju.jpg"
    @State private var image: UIImage?
    @State var offset: CGFloat = 0
    @GestureState var isDragging: Bool = false
    @State var endSwipe: Bool = false
    
    var body: some View {
        GeometryReader {proxy in
            let size = proxy.size
            
            let index = CGFloat(discoveryVM.getIndex(user: user))
            let topOffset = (index <= 2 ? index: 2) * 15
            
            ZStack {
                
                if let image = self.image {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: size.width - topOffset, height: size.height)
                        .cornerRadius(15)
                        .offset(y: -topOffset)
                } else {
                    AsyncImage (
                        url: URL(string: user.profileImage),
                        content: { image in
                            image.resizable()
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: size.width - topOffset, height: size.height)
                                .cornerRadius(15)
                                .offset(y: -topOffset)
                        },
                        placeholder: {
                            ProgressView()
                                .frame(width: size.width - topOffset, height: size.height)
                                .cornerRadius(15)
                                .offset(y: -topOffset)
                                .background(Color(uiColor: .systemGray6))
                        }
                    )
                }
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }
        .offset(x: offset)
        .rotationEffect(.init(degrees: getRotation(angle: 8)))
        .contentShape(Rectangle().trim(from: 0, to: endSwipe ? 0: 1))
        .gesture(
            DragGesture()
                .updating($isDragging, body: { value, out, _ in
                    out = true
                })
                .onChanged({value in
                    let translation = value.translation.width
                    offset = (isDragging ? translation: .zero)
                })
                .onEnded({ value in
                    let width = getRect().width - 50
                    let translation = value.translation.width
                    
                    let checkingStatus = (translation > 0 ? translation: -translation)
                    
                    withAnimation{
                        if checkingStatus > (width / 2) {
                            // Remove card
                            offset = (translation > 0 ? width : -width) * 2
                            endSwipeActions()
                            
                            if translation > 0  {
                                rightSwipe()
                            }
                            else {
                                leftSwipe(receiver: user.id ?? "")
                            }
                        }
                        else {
                            offset = .zero
                            
                        }
                    }

                })
        )
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("ACTIONFROMBUTTON"), object: nil)) {data in
            
            guard let info = data.userInfo else {
                return
            }
            
            let id = info["id"] as? String ?? ""
            let rightSwipe = info["rightSwipe"] as? Bool ?? false
            let width = getRect().width - 50
            if user.id == id {
                withAnimation{
                    offset = (rightSwipe ? width : -width) * 2
                    endSwipeActions()
                    
                    if rightSwipe  {
                        self.rightSwipe()
                    }
                    else {
                        leftSwipe(receiver: user.id ?? "")
                    }
                }
            }
            
        }
    }
    
    func getRotation(angle: Double) -> Double {
        let rotation = (offset / (getRect().width - 50)) * angle
        return rotation
    }
    
    func endSwipeActions() {
        withAnimation(.none) {
            endSwipe = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            if let _ = discoveryVM.displayingUsers.first{
                let _ = withAnimation{
                    discoveryVM.displayingUsers.removeFirst()
                }
            }
        }
    }
    
    func leftSwipe(receiver: String) {
        discoveryVM.createMatch(receiver: receiver)
    }
    
    func rightSwipe() {
        
    }
}

// Extending view to get bounds
extension View {
    func getRect()->CGRect{
        return UIScreen.main.bounds
    }
}
