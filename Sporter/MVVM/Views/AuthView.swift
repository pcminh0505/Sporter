//
//  AuthenticationView.swift
//  Sporter
//
//  Created by Minh Pham on 30/08/2022.
//  https://kavsoft.dev/swift_email_login

import SwiftUI
import Firebase

struct AuthView: View {
    var body: some View {
        Home()
    }
}

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView()
    }
}

struct Home: View {

    @State var show = false
    @State var status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false

    var body: some View {

        NavigationView {

            VStack {

                if self.status {

                    HomeView()
                }
                else {

                    ZStack {

                        NavigationLink(destination: SignUp(show: self.$show), isActive: self.$show) {

                            Text("")
                        }
                            .hidden()

                        Login(show: self.$show)
                    }
                }
            }
                .navigationBarTitle("")
                .navigationBarHidden(true)
                .navigationBarBackButtonHidden(true)
                .onAppear {

                NotificationCenter.default.addObserver(forName: NSNotification.Name("status"), object: nil, queue: .main) { (_) in

                    self.status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
                }
            }
        }
    }
}

struct Login: View {

    @State var color = Color.black.opacity(0.7)
    @State var email = ""
    @State var pass = ""
    @State var visible = false
    @Binding var show: Bool
    @State var alert = false
    @State var error = ""

    var body: some View {

        ZStack {

            ZStack(alignment: .topTrailing) {

                GeometryReader { _ in

                    VStack {

//                        Image("logo")

                        Text("Log in to your account")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(self.color)
                            .padding(.top, 35)

                        TextField("Email", text: self.$email)
                            .autocapitalization(.none)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 4).stroke(self.email != "" ? Color.blue : self.color, lineWidth: 2))
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
                            .background(RoundedRectangle(cornerRadius: 4).stroke(self.pass != "" ? Color.blue : self.color, lineWidth: 2))
                            .padding(.top, 25)

                        HStack {

                            Spacer()

                            Button(action: {

                                self.reset()

                            }) {

                                Text("Forget password")
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.blue)
                            }
                        }
                            .padding(.top, 20)

                        Button(action: {

                            self.verify()

                        }) {

                            Text("Log in")
                                .foregroundColor(.white)
                                .padding(.vertical)
                                .frame(width: UIScreen.main.bounds.width - 50)
                        }
                            .background(Color.blue)
                            .cornerRadius(10)
                            .padding(.top, 25)

                    }
                        .padding(.horizontal, 25)
                }

                Button(action: {

                    self.show.toggle()

                }) {

                    Text("Register")
                        .fontWeight(.bold)
                        .foregroundColor(Color.blue)
                }
                    .padding()
            }

            if self.alert {

                ErrorView(alert: self.$alert, error: self.$error)
            }
        }
    }

    func verify() {

        if self.email != "" && self.pass != "" {

            Auth.auth().signIn(withEmail: self.email, password: self.pass) { (res, err) in

                if err != nil {

                    self.error = err!.localizedDescription
                    self.alert.toggle()
                    return
                }

                print("success")
                UserDefaults.standard.set(true, forKey: "status")
                NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
            }
        }
        else {

            self.error = "Please fill all the contents properly"
            self.alert.toggle()
        }
    }

    func reset() {

        if self.email != "" {

            Auth.auth().sendPasswordReset(withEmail: self.email) { (err) in

                if err != nil {

                    self.error = err!.localizedDescription
                    self.alert.toggle()
                    return
                }

                self.error = "RESET"
                self.alert.toggle()
            }
        }
        else {

            self.error = "Email Id is empty"
            self.alert.toggle()
        }
    }
}

struct SignUp: View {

    @State var color = Color.black.opacity(0.7)

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

    var body: some View {

        ZStack {

            ZStack(alignment: .topLeading) {

                GeometryReader { _ in

                    VStack {

//                        Image("logo")

                        Text("Register a new account")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(self.color)
                            .padding(.top, 35)

                        HStack (spacing: 15) {
                            TextField("First Name", text: self.$fname)
                                .autocapitalization(.none)
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 4).stroke(self.fname != "" ? Color.blue : self.color, lineWidth: 2))
                                .padding(.top, 25)
                            TextField("Last Name", text: self.$lname)
                                .autocapitalization(.none)
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 4).stroke(self.lname != "" ? Color.blue : self.color, lineWidth: 2))
                                .padding(.top, 25)
                        }

                        TextField("Phone Number", text: self.$phone)
                            .autocapitalization(.none)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 4).stroke(self.phone != "" ? Color.blue : self.color, lineWidth: 2))
                            .padding(.top, 25)

                        TextField("Email", text: self.$email)
                            .autocapitalization(.none)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 4).stroke(self.email != "" ? Color.blue : self.color, lineWidth: 2))
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
                            .background(RoundedRectangle(cornerRadius: 4).stroke(self.pass != "" ? Color.blue : self.color, lineWidth: 2))
                            .padding(.top, 25)

                        HStack(spacing: 15) {

                            VStack {

                                if self.revisible {

                                    TextField("Re-enter", text: self.$repass)
                                        .autocapitalization(.none)
                                }
                                else {

                                    SecureField("Re-enter", text: self.$repass)
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
                            .background(RoundedRectangle(cornerRadius: 4).stroke(self.repass != "" ? Color.blue : self.color, lineWidth: 2))
                            .padding(.top, 25)

                        Button(action: {

                            self.register()
                        }) {

                            Text("Register")
                                .foregroundColor(.white)
                                .padding(.vertical)
                                .frame(width: UIScreen.main.bounds.width - 50)
                        }
                            .background(Color.blue)
                            .cornerRadius(10)
                            .padding(.top, 25)

                    }
                        .padding(.horizontal, 25)
                }

                Button(action: {

                    self.show.toggle()

                }) {

                    Image(systemName: "chevron.left")
                        .font(.title)
                        .foregroundColor(Color.blue)
                }
                    .padding()
            }

            if self.alert {

                ErrorView(alert: self.$alert, error: self.$error)
            }
        }
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
    }

    func register() {
        let userRepo: UserRepository = UserRepository()
        if (self.email != "" && self.fname != "" && self.lname != "" && self.phone != "") {

            if self.pass == self.repass {

                Auth.auth().createUser(withEmail: self.email, password: self.pass) { (res, err) in

                    if err != nil {

                        self.error = err!.localizedDescription
                        self.alert.toggle()
                        return
                    }

                    print("success")
                    // Get generated ID and push to Firestore
                    let id = Auth.auth().currentUser?.uid
                    userRepo.createUser(User(id: id!,
                                             fname: self.fname.trimmingCharacters(in: .whitespacesAndNewlines),
                                             lname: self.lname.trimmingCharacters(in: .whitespacesAndNewlines),
                                             email: self.email.trimmingCharacters(in: .whitespacesAndNewlines),
                                             phone: self.phone.trimmingCharacters(in: .whitespacesAndNewlines),
                                             friends: []))

                    UserDefaults.standard.set(true, forKey: "status")
                    NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
                }
            }
            else {

                self.error = "Password mismatch"
                self.alert.toggle()
            }
        }
        else {

            self.error = "Please fill all the contents properly"
            self.alert.toggle()
        }
    }
}


struct ErrorView: View {

    @State var color = Color.black.opacity(0.7)
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
                    .padding(.horizontal, 25)

                Button(action: {

                    self.alert.toggle()

                }) {

                    Text(self.error == "RESET" ? "Ok" : "Cancel")
                        .foregroundColor(.white)
                        .padding(.vertical)
                        .frame(width: UIScreen.main.bounds.width - 120)
                }
                    .background(Color.blue)
                    .cornerRadius(10)
                    .padding(.top, 25)

            }
                .padding(.vertical, 25)
                .frame(width: UIScreen.main.bounds.width - 70)
                .background(Color.white)
                .cornerRadius(15)
        }
            .background(Color.black.opacity(0.35).edgesIgnoringSafeArea(.all))
    }
}
