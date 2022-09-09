//
//  SignUpView.swift
//  Sporter
//
//  Created by Minh Pham on 09/09/2022.
//

import SwiftUI
import Firebase

struct SignUpView: View {
    enum Gender: String, CaseIterable, Identifiable {
        case male
        case female
        case other
        var id: String { self.rawValue }
    }

    @State var color = Color.theme.textColor.opacity(0.7)
    @State var gender: Gender = .male
    @State var birthDate: Date = Date()
    @State var fname = ""
    @State var lname = ""
    @State var phone = ""
    @State var email = ""
    @State var pass = ""
    @State var repass = ""
    @State var visible = false
    @State var revisible = false
    @Binding var show: Bool
    @State var alert = false
    @State var error = ""

    @State var isLoading: Bool = false

    var body: some View {
        ZStack {
            GeometryReader { _ in
                ScrollView {
                    VStack {
                        Image("Logo")
                            .padding(.top, 25)

                        Text("Register a new account")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(self.color)
                            .padding(.top, 35)

                        HStack (spacing: 15) {
                            TextField("First Name", text: self.$fname)
                                .autocapitalization(.none)
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 4).stroke(self.fname != "" ? Color.accentColor : self.color, lineWidth: 2))
                                .padding(.top, 25)
                            TextField("Last Name", text: self.$lname)
                                .autocapitalization(.none)
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 4).stroke(self.lname != "" ? Color.accentColor : self.color, lineWidth: 2))
                                .padding(.top, 25)
                        }

                        VStack {
                            DatePicker(selection: $birthDate, in: ...Date(), displayedComponents: .date) {
                                Text("Day of Birth")
                            }
                            Picker("Gender", selection: $gender) {
                                ForEach(Gender.allCases) { gender in
                                    Text(gender.rawValue.capitalized).tag(gender)
                                }
                            }
                                .pickerStyle(SegmentedPickerStyle())
                        }
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 4).stroke(Color.accentColor, lineWidth: 2))
                            .padding(.top, 25)

                        TextField("Phone Number (+84)", text: self.$phone)
                            .autocapitalization(.none)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 4).stroke(self.phone != "" ? Color.accentColor : self.color, lineWidth: 2))
                            .padding(.top, 25)

                        TextField("Email", text: self.$email)
                            .autocapitalization(.none)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 4).stroke(self.email != "" ? Color.accentColor : self.color, lineWidth: 2))
                            .padding(.top, 25)

                        HStack(spacing: 15) {

                            VStack {

                                if self.visible {

                                    TextField("Password", text: self.$pass)
                                        .autocapitalization(.none)
                                }
                                else {

                                    SecureField("Password", text: self.$pass)
                                        .autocapitalization(.none)
                                }
                            }

                            Button(action: {
                                self.visible.toggle()
                            }) {

                                Image(systemName: self.visible ? "eye.slash.fill" : "eye.fill")
                                    .foregroundColor(self.color)
                            }

                        }
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 4).stroke(self.pass != "" ? Color.accentColor : self.color, lineWidth: 2))
                            .padding(.top, 25)

                        HStack(spacing: 15) {
                            VStack {
                                if self.revisible {
                                    TextField("Re-enter", text: self.$repass)
                                        .autocapitalization(.none)
                                }
                                else {
                                    SecureField("Confirm Password", text: self.$repass)
                                        .autocapitalization(.none)
                                }
                            }

                            Button(action: {
                                self.revisible.toggle()
                            }) {
                                Image(systemName: self.revisible ? "eye.slash.fill" : "eye.fill")
                                    .foregroundColor(self.color)
                            }

                        }
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 4).stroke(self.repass != "" ? Color.accentColor : self.color, lineWidth: 2))
                            .padding(.top, 25)

                        Button(action: {
                            self.register()
                        }) {
                            if self.isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .padding(.vertical)
                                    .frame(width: UIScreen.main.bounds.width - 50)
                            } else {
                                Text("Register")
                                    .foregroundColor(.white)
                                    .padding(.vertical)
                                    .frame(width: UIScreen.main.bounds.width - 50)
                            }
                        }
                            .background(Color.accentColor)
                            .cornerRadius(10)
                            .padding(.top, 25)

                        HStack {
                            Text("Already have an account?")
                                .foregroundColor(Color.theme.darkGray)
                                .fontWeight(.bold)
                            Button(action: {
                                self.show.toggle()
                            }) {
                                Text("Login")
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.accentColor)
                            }

                        }
                            .padding()

                    }
                        .padding(.horizontal, 25)
                }
            }

            if self.alert {
                ErrorView(alert: self.$alert, error: self.$error)
            }
        }
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
    }

    func register() {
        self.isLoading = true
        let userRepo: UserRepository = UserRepository()
        if (!self.email.isBlank &&
                !self.fname.isBlank &&
                !self.lname.isBlank &&
                !self.phone.isBlank) {

            if !self.email.isValidEmail {
                self.error = "Email is invalid. Please try again"
                self.alert.toggle()
                self.isLoading = false
                return
            }

            if !self.phone.isValidPhoneNumber {
                self.error = "Phone number is invalid. Please try again"
                self.alert.toggle()
                self.isLoading = false
                return
            }

            if self.pass == self.repass {
                Auth.auth().createUser(withEmail: self.email, password: self.pass) { (res, err) in

                    if err != nil {
                        self.error = err!.localizedDescription
                        self.alert.toggle()
                        self.isLoading = false
                        return
                    }
                    // Get generated ID and push to Firestore
                    let id = Auth.auth().currentUser?.uid
                    userRepo.createUser(User(id: id!,
                                             fname: self.fname.trimmingCharacters(in: .whitespacesAndNewlines),
                                             lname: self.lname.trimmingCharacters(in: .whitespacesAndNewlines),
                                             gender: self.gender.rawValue,
                                             bod: self.birthDate.timeIntervalSince1970,
                                             email: self.email.trimmingCharacters(in: .whitespacesAndNewlines),
                                             phone: self.phone.trimmingCharacters(in: .whitespacesAndNewlines),
                                             friends: []))

                    UserDefaults.standard.set(true, forKey: "status")
                    NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
                    self.isLoading = false
                }
            }
            else {
                self.error = "Password mismatch"
                self.alert.toggle()
                self.isLoading = false
            }
        }
        else {
            self.error = "Please fill all the contents properly"
            self.alert.toggle()
            self.isLoading = false
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView(show: .constant(true))
    }
}
