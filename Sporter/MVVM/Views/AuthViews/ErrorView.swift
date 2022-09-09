//
//  ErrorView.swift
//  Sporter
//
//  Created by Minh Pham on 09/09/2022.
//

import SwiftUI

struct ErrorView: View {
    @State var color = Color.theme.textColor.opacity(0.7)
    @Binding var alert: Bool
    @Binding var error: String
    var body: some View {
        GeometryReader { _ in
            VStack {
                HStack {
                    Text(self.error == "RESET" ? "Message" : "Error")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(self.color)

                    Spacer()
                }
                    .padding(.horizontal, 25)

                Text(self.error == "RESET" ? "Password reset link has been sent successfully" : self.error)
                    .foregroundColor(self.color)
                    .padding(.top)
                    .padding(.horizontal, 15)

                Button(action: {
                    self.alert.toggle()
                }) {
                    Text(self.error == "RESET" ? "Ok" : "Cancel")
                        .foregroundColor(.white)
                        .padding(.vertical)
                        .frame(width: UIScreen.main.bounds.width - 120)
                }
                    .background(Color.accentColor)
                    .cornerRadius(10)
                    .padding(.top, 25)
            }
                .padding(.vertical, 25)
                .frame(width: UIScreen.main.bounds.width - 70)
                .background(Color.theme.popupColor)
                .cornerRadius(15)
        }
            .offset(x: UIScreen.main.bounds.width / 11, y: UIScreen.main.bounds.height / 4)
            .background(Color.black.opacity(0.35).edgesIgnoringSafeArea(.all))
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView(alert: .constant(true), error: .constant("Please try again"))
    }
}
