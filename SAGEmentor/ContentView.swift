//
//  ContentView.swift
//  SAGEmentor
//
//  Created by brad.hontz on 1/24/20.
//  Copyright © 2020 brad.hontz. All rights reserved.
//

import SwiftUI
import Firebase
import GoogleSignIn

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Log In with Gmail:")
                // Spacer()
                googleLogIn().frame(width:120, height:50)
                Button(action: {
                    print("Signing out...")
                    GIDSignIn.sharedInstance().signOut()
                    let firebaseAuth = Auth.auth()
                    do {
                        try firebaseAuth.signOut()
                    } catch let signOutError as NSError {
                        print("Error signing out of Firebase: %@", signOutError)
                        return
                    }
                    print("Signed out of Firebase and Google!")
                }) {
                    Text("Sign out")
                }
            }

        }.navigationBarTitle(Text("Login"))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
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
