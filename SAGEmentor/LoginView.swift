//
//  LoginView.swift
//  SAGEmentor
//
//  Created by brad.hontz on 1/26/20.
//  Copyright © 2020 brad.hontz. All rights reserved.
//

import SwiftUI
import GoogleSignIn
import Firebase

struct LoginView: View {
    @Binding var results : [Result]
    @State private var pushed: Bool = false
    var body: some View {
        VStack {
            Button(action: {
                SocialLogin().attemptLoginGoogle()
                // be great if you could WAIT for the operation above to complete!!
                // alteratively, explore loading a separate screen modally, perhaps google log in
                self.pushed = true
            }, label: {Image("google_signin")
                        .resizable()
                        .frame(width:400, height:100)

            })
            NavigationLink(destination: ToWelcomeView(pushed: $pushed, results: $results), isActive: $pushed) { EmptyView()}
// // this is another way of presenting the log in
//            Text("Login with Google:")
//            googleLogIn().frame(width:120, height:50)
//            Divider()
//            Button("Welcome View") {
//                self.pushed.toggle()
//            }
//            NavigationLink(destination: ToWelcomeView(pushed: $pushed, results: $results), isActive: $pushed) { EmptyView() }
        }
    }
}

struct ToWelcomeView: View {
    @Binding var pushed: Bool
    @Binding var results : [Result]
    var body: some View {
        WelcomeView(results: $results)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: BackToLogin(label:"Sign In as another user") {
                self.pushed = false
            })
    }
}

struct BackToLogin: View {
    let label: String
    let closure: () -> ()

    var body: some View {
        Button(action: { self.signOut(); self.closure() }) {
            HStack {
                Image(systemName: "chevron.left")
                Text(label)
            }
        }
    }
    func signOut() {
        print("Signing out... ")
        currentUser = UserInfo(username:"", emailaddress:"")
        GIDSignIn.sharedInstance().signOut()
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print("Error signing out of Firebase: %@", signOutError)
            return
        }
        print("Signed out of Firebase and Google!")
    }
}


// You only need this if your using the "button()" methodology of calling the google signin process
struct SocialLogin: UIViewRepresentable {

    func makeUIView(context: UIViewRepresentableContext<SocialLogin>) -> UIView {
        return UIView()
    }

    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<SocialLogin>) {
    }

    func attemptLoginGoogle() {
        GIDSignIn.sharedInstance()?.presentingViewController = UIApplication.shared.windows.last?.rootViewController
        GIDSignIn.sharedInstance()?.signIn()
    }

}

struct googleLogIn: UIViewRepresentable {
    func makeUIView(context: UIViewRepresentableContext<googleLogIn>) -> GIDSignInButton {
        let button = GIDSignInButton()
        button.colorScheme = .dark
        GIDSignIn.sharedInstance()?.presentingViewController = UIApplication.shared.windows.last?.rootViewController

        return button
    }
    func updateUIView(_ uiView: GIDSignInButton, context: UIViewRepresentableContext<googleLogIn>) {
    }
}

//struct LoginView_Previews: PreviewProvider {
//    static var previews: some View {
//        LoginView()
//    }
//}

struct LoginView_Previews: PreviewProvider {
    struct BindingTestHolder: View {
        @State var testItem: [Result] = [Result(date: "test", quote: "test")]
        var body: some View {
            LoginView(results: $testItem)
        }
    }
    static var previews: some View {
        BindingTestHolder()
    }
}
