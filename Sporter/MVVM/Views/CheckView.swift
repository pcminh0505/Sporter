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

struct CheckView: View {
    @State var show = false
    @State var status = UserDefaults.standard.value(forKey: "authStatus") as? Bool ?? false

    var body: some View {
        NavigationView {
            ZStack {
                if self.status {
                    HomeView()
                }
                else {
                    ZStack {
                        LoginView(show: self.$show).navigationBarHidden(true)
                        NavigationLink(
                            destination: SignUpView(show: self.$show)
                                .navigationBarHidden(true),
                            isActive: self.$show) {
                            EmptyView()
                        }
                            .hidden()
                    }
                }
            }
                .onAppear {

                NotificationCenter.default.addObserver(forName: NSNotification.Name("authStatus"), object: nil, queue: .main) { (_) in
                    self.status = UserDefaults.standard.value(forKey: "authStatus") as? Bool ?? false
                }
            }
        }
    }
}

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        CheckView()
    }
}
