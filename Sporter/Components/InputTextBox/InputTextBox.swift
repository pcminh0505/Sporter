//
//  InputTextBox.swift
//  Sporter
//
//  Created by Minh Pham on 11/09/2022.
//

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
        InputTextBox(title: "Phone Number", text: .constant("01234"), placeholder: "+84...", validation: "Must include country code. Eg. +84...")
    }
}
