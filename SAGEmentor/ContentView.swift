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
    @EnvironmentObject var session: SessionStore

    var body: some View {
        NavigationView {
            VStack {
                if session.isLoggedIn == true {
                    WelcomeView(results: $results)
                } else {
                    Button(action: {
                        SocialLogin().attemptLoginGoogle()
                    }, label: {Image("google_signin")
                                .resizable()
                                .frame(width:400, height:100)
                    })
                }
            }
            .onAppear(perform: listenAndLoad)
            .navigationBarTitle("Welcome", displayMode: .inline)
        }
    }

    func listenAndLoad () {
        loadData()
        self.session.listen() // listen to see if we have a user yet (or not)
    }

    // this function loads performs the API call
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

// this is a DEBUGGING function you can add to views to facilitate printing out variables to the console
//extension View {
//    func Print(_ vars: Any...) -> some View {
//        for v in vars { print(v) }
//        return EmptyView()
//    }
//}

// structure for signing in with Google
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
