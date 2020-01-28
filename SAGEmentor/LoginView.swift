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
    
    var body: some View {
        VStack {
            Text("Login with Google:")
            googleLogIn().frame(width:120, height:50)
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
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
