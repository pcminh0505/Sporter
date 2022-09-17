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
    let defaultImageURL: String =
        "https://t4.ftcdn.net/jpg/00/64/67/63/360_F_64676383_LdbmhiNM6Ypzb3FM4PPuFP9rHe7ri8Ju.jpg"
    @State private var image: UIImage?
    @State var offset: CGFloat = 0
    @GestureState var isDragging: Bool = false
    @State var endSwipe: Bool = false

    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size

            let index = CGFloat(discoveryVM.getIndex(user: user))
            let topOffset = (index <= 2 ? index : 2) * 15
            let scale = 0.95

            ZStack {
                // User Image
                VStack {
                    if let image = self.image {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(
                                width: size.width * scale - topOffset * scale - 20,
                                height: size.height * scale
                        )
                            .cornerRadius(15)
                            .offset(y: -topOffset * scale)
                    } else {
                        // Fetch image from storage
                        AsyncImage(
                            url: URL(string: user.profileImage),
                            content: { image in
                                image.resizable()
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(
                                        width: size.width - topOffset * scale - 20,
                                        height: size.height * scale)
                                    .cornerRadius(15)
                                    .offset(y: -topOffset * scale)
                            },
                            placeholder: {
                                ProgressView()
                                    .frame(
                                        width: size.width - topOffset * scale - 20,
                                        height: size.height * scale
                                )
                                    .cornerRadius(15)
                                    .offset(y: -topOffset * scale)
                                    .background(Color.white)
                            }
                        )
                    }
                }
                    .shadow(color: .gray, radius: 10)
                
                // Card Information
                VStack {
                    Spacer() // Push the floating box down
                    
                    VStack(alignment: .leading, spacing: 5) {
                        HStack {
                            Text("\(user.fname) \(user.lname), \(getAge(bod: user.bod)) \(user.gender.capitalized == "Male" ? "M" : "F")")
                                .font(.title)
                                .bold()
                            Spacer()
                        }
                            .padding(.bottom, 5)
                        
                        HStack {
                            VStack (alignment: .center) {
                                Image(systemName: "rosette")
                                Image(systemName: "target")
                            }
                            VStack (alignment: .leading) {
                                HStack {
                                    Text("Level:").bold()
                                    Text("\(user.level.capitalized)")
                                }
                                HStack {
                                    Text("Goal:").bold()
                                    Text("\(user.sportType.capitalized)")
                                }
                            }
                        }
                    }
                        .padding(25)
                        .cornerRadius(30)
                        .foregroundColor(Color.theme.textColor)
                        .background(RoundedRectangle(cornerRadius: 15)
                            .fill(Color.white)
                            .shadow(radius: 10)
                            .opacity(0.65))
                }
                    .padding(30)
                    .offset(y: -(topOffset * scale + 15))
            }
                .frame(alignment: .center)
        }
            .offset(x: offset)
            .rotationEffect(.init(degrees: getRotation(angle: 8)))
            .contentShape(Rectangle().trim(from: 0, to: endSwipe ? 0 : 1))
            .gesture(
            DragGesture()
                .updating(
                $isDragging,
                body: { value, out, _ in
                    out = true
                }
            )
                .onChanged({ value in
                let translation = value.translation.width
                offset = (isDragging ? translation : .zero)
            })
                .onEnded({ value in
                let width = getRect().width - 50
                let translation = value.translation.width

                let checkingStatus = (translation > 0 ? translation : -translation)

                withAnimation {
                    if checkingStatus > (width / 2) {
                        // Remove card
                        offset = (translation > 0 ? width : -width) * 2
                        endSwipeActions()

                        if translation > 0 {
                            rightSwipe(receiver: user.id ?? "")
                        } else {
                            leftSwipe()
                        }
                    } else {
                        offset = .zero
                    }
                }

            })
        )
            .onReceive(
            NotificationCenter.default.publisher(
                for: Notification.Name("ACTIONFROMBUTTON"), object: nil)
        ) { data in

            // Check if user information is valid
            guard let info = data.userInfo else {
                return
            }

            // Create new match from user ID
            let id = info["id"] as? String ?? ""
            let rightSwipe = info["rightSwipe"] as? Bool ?? false
            let width = getRect().width - 50
            if user.id == id {
                withAnimation {
                    offset = (rightSwipe ? width : -width) * 2
                    endSwipeActions()

                    if rightSwipe {
                        self.rightSwipe(receiver: user.id ?? "")
                    } else {
                        leftSwipe()
                    }
                }
            }

        }
    }

    // Get card rotation
    func getRotation(angle: Double) -> Double {
        let rotation = (offset / (getRect().width - 50)) * angle
        return rotation
    }

    // Remove swiped user from stack
    func endSwipeActions() {
        withAnimation(.none) {
            endSwipe = true
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            if let _ = discoveryVM.displayingUsers.first {
                let _ = withAnimation {
                    discoveryVM.displayingUsers.removeFirst()
                }
            }
        }
    }

    func leftSwipe() {
        // Do nothing
    }

    // Create a match
    func rightSwipe(receiver: String) {
        discoveryVM.createMatch(receiver: receiver)
    }

    // Util to get user age from birthday
    func getAge(bod: TimeInterval) -> Int {
        let birthday = NSDate(timeIntervalSince1970: bod)
        let now = Date()
        let calendar = Calendar.current

        let ageComponents = calendar.dateComponents([.year], from: birthday as Date, to: now)
        return ageComponents.year!
    }
}

// Extending view to get bounds
extension View {
    func getRect() -> CGRect {
        return UIScreen.main.bounds
    }
}

struct Stackcard_Previews: PreviewProvider {
    static var previews: some View {
        DiscoveryView()
    }
}
