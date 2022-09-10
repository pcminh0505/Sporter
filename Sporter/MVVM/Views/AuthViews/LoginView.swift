//
//  Login.swift
//  Sporter
//
//  Created by Minh Pham on 09/09/2022.
//

import SwiftUI
import Firebase

struct LoginView: View {
    @State var color = Color.theme.textColor.opacity(0.7)
    @State var email = ""
    @State var pass = ""
    @State var visible = false
    @Binding var show: Bool
    @State var alert = false
    @State var error = ""

    @State var isLoading: Bool = false
    @State var isResetting: Bool = false
    
    var body: some View {
        ZStack {
            GeometryReader { _ in
                VStack {
                    Image("Logo")
                        .padding(.top, 25)
                    Text("Log in to your account")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(self.color)
                        .padding(.top, 35)

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

                    HStack {
                        Spacer()
                        Button(action: {
                            self.reset()
                        }) {
                            if isResetting {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: Color.accentColor))
                            } else {
                                Text("Forget password?")
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.accentColor)
                            }
                        }
                    }
                        .padding(.top, 20)

                    Button(action: {
                        self.verify()
                    }) {
                        if isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .padding(.vertical)
                                .frame(width: UIScreen.main.bounds.width - 50)
                        } else {
                            Text("Log in")
                                .foregroundColor(.white)
                                .padding(.vertical)
                                .frame(width: UIScreen.main.bounds.width - 50)
                        }
                    }
                        .background(Color.accentColor)
                        .cornerRadius(10)
                        .padding(.top, 25)


                    HStack {
                        Text("Don't have an account?")
                            .foregroundColor(Color.theme.darkGray)
                            .fontWeight(.bold)
                        Button(action: {
                            self.show.toggle()
                        }) {
                            Text("Register")
                                .fontWeight(.bold)
                                .foregroundColor(Color.accentColor)
                        }
                    }
                        .padding()
                }
                    .padding(.horizontal, 25)


            }
            if self.alert {
                ErrorView(alert: self.$alert, error: self.$error)
            }
        }
            .navigationBarHidden(true)
    }

    func verify() {
        self.isLoading = true
        if self.email != "" && self.pass != "" {
            Auth.auth().signIn(withEmail: self.email, password: self.pass) { (res, err) in
                if err != nil {
                    self.error = err!.localizedDescription
                    self.alert.toggle()
                    self.isLoading = false
                    return
                }
                
                // Get generated ID and push to Firestore
                let id = res!.user.uid

                // Add to userDefaults
                UserDefaults.standard.set(id, forKey: "currentUser")
                UserDefaults.standard.set(true, forKey: "authStatus")
                NotificationCenter.default.post(name: NSNotification.Name("authStatus"), object: nil)
                self.isLoading = false
            }
        }
        else {
            self.error = "Please fill all the contents properly"
            self.alert.toggle()
            self.isLoading = false
        }

    }

    func reset() {
        self.isResetting = true
        if !self.email.isBlank {
            Auth.auth().sendPasswordReset(withEmail: self.email) { (err) in
                if err != nil {
                    self.error = err!.localizedDescription
                    self.alert.toggle()
                    return
                }
                self.error = "RESET"
                self.alert.toggle()
            }
            self.isResetting = false
        }
        else {
            self.error = "Email is empty or invalid"
            self.alert.toggle()
            self.isResetting = false
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(show: .constant(true))
            .preferredColorScheme(.dark)
    }
}
