//
//  ContentView.swift
//  SAGEmentor
//
//  Created by brad.hontz on 1/24/20.
//  Copyright © 2020 brad.hontz. All rights reserved.
//

import SwiftUI
import GoogleSignIn
import Firebase

struct ContentView: View {
    @State private var pushed: Bool = false
    @State private var results: [Result] = [Result(date:"empty", quote:"empty")]

    var body: some View {
        NavigationView {
            VStack {
                LoginView()
                Divider()
                Button("Welcome View") {
                    self.pushed.toggle()
                }
                NavigationLink(destination: ToWelcomeView(pushed: $pushed, results: $results), isActive: $pushed) { EmptyView() }
            }.onAppear(perform:loadData)
        }
    }
    
    func loadData() {
        guard let url = URL(string: "https://quotes.rest/qod.json?category=inspire") else {
            print("invalid URL!")
            return
        }
        let request = URLRequest(url: url)

        URLSession.shared.dataTask(with: request) {data, response, error in
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode(Response.self, from: data) {
                    DispatchQueue.main.async {
                        self.results = decodedResponse.contents.quotes
                    }
                }
                return
            }
            print("fetch failed: \(error?.localizedDescription ?? "Unknown Error")")
        }.resume()
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
