/*
    RMIT University Vietnam
    Course: COSC2659 iOS Development
    Semester: 2022B
    Assessment: Assignment 3
    Author: Minh Pham
    ID: s3818102
    Created date: 11/09/2022
    Last modified: 18/09/2022
*/

import SwiftUI

struct InputTextBox: View {
    let color = Color.theme.textColor.opacity(0.7)

    let title: String
    @Binding var text: String
    let placeholder: String
    var validation: String = ""
    var numberOnly: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .font(.headline)

            if (numberOnly) {
                TextField("\(placeholder)", text: $text)
                    .keyboardType(.decimalPad)
                    .autocapitalization(.none)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 4).stroke(text != "" ? Color.accentColor : color, lineWidth: 2))
            } else {
                TextField("\(placeholder)", text: $text)
                    .autocapitalization(.none)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 4).stroke(text != "" ? Color.accentColor : color, lineWidth: 2))
            }
            if (validation != "") {
                Text(validation)
                    .font(.caption)
                    .italic()
            }
        }
            .padding(.top, 25)
    }
}
struct InputTextBox_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            InputTextBox(title: "Phone Number", text: .constant("01234"), placeholder: "+84...", validation: "Must include country code, e.g., +84...")
            InputTextBox(title: "Phone Number", text: .constant("01234"), placeholder: "+84...", validation: "Must include country code, e.g., +84...")
                .preferredColorScheme(.dark)
        }
    }
}
