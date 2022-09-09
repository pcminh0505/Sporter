//
//  AuthenticationView.swift
//  Sporter
//
//  Created by Minh Pham on 30/08/2022.
//  https://kavsoft.dev/swift_email_login

import SwiftUI
import Firebase

struct CheckView: View {
    @State var show = false
    @State var status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false

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

                NotificationCenter.default.addObserver(forName: NSNotification.Name("status"), object: nil, queue: .main) { (_) in
                    self.status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
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
