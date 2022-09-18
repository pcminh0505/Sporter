/*
    RMIT University Vietnam
    Course: COSC2659 iOS Development
    Semester: 2022B
    Assessment: Assignment 3
    Author: Minh Pham
    ID: s3818102
    Created date: 09/09/2022
    Last modified: 18/09/2022
    Acknowledgement: https://kavsoft.dev/swift_email_login
*/

import SwiftUI
import Firebase

struct SignUpView: View {
    @ObservedObject var keyboardResponder = KeyboardResponder()
    
    let color = Color.theme.textColor.opacity(0.7)
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
                        VStack {
                            Image("Logo")
                                .padding(.top, 25)
                            Text("Register a new account")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(self.color)
                                .padding(.top, 35)
                        }

                        HStack (spacing: 15) {
                            InputTextBox(title: "First Name",
                                         text: self.$fname,
                                         placeholder: "John")

                            InputTextBox(title: "Last Name",
                                         text: self.$lname,
                                         placeholder: "Smith")
                        }


                        VStack {
                            DatePicker(selection: $birthDate, in: ...Date(), displayedComponents: .date) {
                                Text("Day of Birth")
                                    .font(.headline)
                            }
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 4).stroke(Color.accentColor, lineWidth: 2))
                                .padding(.top, 25)
                        }

                        VStack(alignment: .leading, spacing: 5) {
                            Text("Gender")
                                .font(.headline)
                            Picker("Gender", selection: $gender) {
                                ForEach(Gender.allCases) { gender in
                                    Text(gender.rawValue.capitalized).tag(gender)
                                }
                            }
                                .pickerStyle(SegmentedPickerStyle())
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 4).stroke(Color.accentColor, lineWidth: 2))
                        }
                            .padding(.top, 25)



                        InputTextBox(title: "Phone Number",
                                     text: self.$phone,
                                     placeholder: "+84...")

                        InputTextBox(title: "Email",
                                     text: self.$email,
                                     placeholder: "abc@gmail.com")


                        VStack(alignment: .leading, spacing: 5) {
                            Text("Password")
                                .font(.headline)
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
                            
                            Text("Minimum of 8 characters, including at least 1 lowercase, 1 uppercase, 1 digit, and 1 special character.")
                                .font(.caption)
                                .italic()
                        }
                            .padding(.top, 25)

                        VStack(alignment: .leading, spacing: 5) {
                            Text("Confirm Password")
                                .font(.headline)
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
                        }
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
                        .offset(y: -keyboardResponder.currentHeight * 0.9)
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
            
            if !self.pass.isValidPassword {
                let pwdErrors = getMissingValidation(str: self.pass)
                self.error = "Invaid password: \(pwdErrors.joined(separator: ", "))."
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

                    guard let id = Auth.auth().currentUser?.uid else {
                        print("Error retreiving ID after Sign Up")
                        return
                    }

                    userRepo.createUser(userID: id,
                                        User(fname: self.fname.trimmingCharacters(in: .whitespacesAndNewlines),
                                             lname: self.lname.trimmingCharacters(in: .whitespacesAndNewlines),
                                             gender: self.gender.rawValue,
                                             bod: self.birthDate.timeIntervalSince1970,
                                             email: self.email.trimmingCharacters(in: .whitespacesAndNewlines),
                                             phone: self.phone.trimmingCharacters(in: .whitespacesAndNewlines)))

                    UserDefaults.standard.set(true, forKey: "authStatus")
                    UserDefaults.standard.set(id, forKey: "currentUser")
                    NotificationCenter.default.post(name: NSNotification.Name("authStatus"), object: nil)
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
    
    func getMissingValidation(str: String) -> [String] {
        var errors: [String] = []
        if(!NSPredicate(format:"SELF MATCHES %@", ".*[A-Z]+.*").evaluate(with: str)){
            errors.append("at least one uppercase")
        }
        
        if(!NSPredicate(format:"SELF MATCHES %@", ".*[0-9]+.*").evaluate(with: str)){
            errors.append("at least one digit")
        }

        if(!NSPredicate(format:"SELF MATCHES %@", ".*[!&^%$#@()/]+.*").evaluate(with: str)){
            errors.append("at least one symbol")
        }
        
        if(!NSPredicate(format:"SELF MATCHES %@", ".*[a-z]+.*").evaluate(with: str)){
            errors.append("at least one lowercase")
        }
        
        if(str.count < 8){
            errors.append("minimum of 8 characters")
        }
        return errors
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView(show: .constant(true))
    }
}
