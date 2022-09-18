/*
    RMIT University Vietnam
    Course: COSC2659 iOS Development
    Semester: 2022B
    Assessment: Assignment 3
    Author: Minh Pham
    ID: s3818102
    Created date: 12/09/2022
    Last modified: 18/09/2022
*/

import SwiftUI

struct SquareButton: View {
    let imgName: String
    
    var body: some View {
        ZStack {
            Image(systemName: "square.fill")
                .resizable()
                .foregroundColor(Color.theme.red)
                .scaledToFit()
                .frame(width: 40, height: 40)
            Image(systemName: imgName)
                .resizable()
                .foregroundColor(.white)
                .scaledToFit()
                .frame(width: 20, height: 20)
        }
    }
}

struct SquareButton_Previews: PreviewProvider {
    static var previews: some View {
        SquareButton(imgName: "person.fill")
    }
}
