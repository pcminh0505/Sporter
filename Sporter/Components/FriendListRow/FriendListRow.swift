//
//  FriendListRow.swift
//  Sporter
//
//  Created by Minh Pham on 16/09/2022.
//

import SwiftUI

struct FriendListRow: View {
    let user: User

    var body: some View {
        HStack {
            AsyncImage (
                url: URL(string: user.profileImage),
                content: { image in
                    image.resizable()
                        .resizable()
                        .scaledToFill()
                        .cornerRadius(50)
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                },
                placeholder: {
                    ProgressView()
                        .cornerRadius(50)
                        .frame(width: 100, height: 100)
                        .background(Color(uiColor: .systemGray6))
                        .clipShape(Circle())
                }
            )
                .overlay(RoundedRectangle(cornerRadius: 50).stroke(Color.theme.textColor))

            VStack (alignment: .leading, spacing: 5) {
                HStack {
                    Text("\(user.fname) \(user.lname) (\(user.gender == "male" ? "M" : "F"))")
                        .font(.title2)
                        .fontWeight(.bold)
                    Spacer()
                    HStack {
                        Text("Age: ").bold()
                        Text("\(ConversionHelper.getAge(user.bod))")
                    }
                        .font(.caption)
                }

                HStack {
                    Text("Phone: ").font(.headline)
                    Text(user.phone)
                }
                
                HStack {
                    Text("Email: ").font(.headline)
                    Text(user.email)
                }
                
                HStack {
                    Text("Level").font(.headline)
                    Button {
                        print("")
                    } label: {
                        Text(user.level.capitalized)
                            .font(.caption)
                    }
                        .buttonStyle(.bordered)
                        .foregroundColor(Color.accentColor)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    Spacer()
                    Text("Goal").font(.headline)
                    Button {
                        print("")
                    } label: {
                        Text(user.sportType.capitalized)
                            .font(.caption2)
                    }
                        .buttonStyle(.bordered)
                        .foregroundColor(Color.accentColor)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }

                .foregroundColor(Color.theme.textColor)
                .padding(.leading, 5)
        }
            .font(.subheadline)
    }
}

struct FriendListRow_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            FriendListRow(user: User.unset)
                .previewLayout(.sizeThatFits)
            FriendListRow(user: User.unset)
                .preferredColorScheme(.dark)
                .previewLayout(.sizeThatFits)
        }
    }
}

