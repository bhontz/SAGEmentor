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
//                Button(action: {
//                    SocialLogin().attemptLoginGoogle()
//                    //self.pushed.toggle()
//                    self.pushed = true
//                }, label: {Image("google_signin")
//                            .resizable()
//                            .frame(width:400, height:100)
//
//                })
//                NavigationLink(destination: ToWelcomeView(pushed: $pushed, results: $results), isActive: $pushed) { EmptyView()}
                LoginView(results: $results)
//                Divider()
//                Button("Welcome View") {
//                    self.pushed.toggle()
//                }
//                NavigationLink(destination: ToWelcomeView(pushed: $pushed, results: $results), isActive: $pushed) { EmptyView() }
            }.onAppear(perform:loadData)  // gets data from the Quote Of the Day API
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

//struct ToWelcomeView: View {
//    @Binding var pushed: Bool
//    @Binding var results : [Result]
//    var body: some View {
//        WelcomeView(results: $results)
//            .navigationBarBackButtonHidden(true)
//            .navigationBarItems(leading: BackToLogin(label:"Sign In as another user") {
//                self.pushed = false
//            })
//    }
//}
//
//struct BackToLogin: View {
//    let label: String
//    let closure: () -> ()
//
//    var body: some View {
//        Button(action: { self.signOut(); self.closure() }) {
//            HStack {
//                Image(systemName: "chevron.left")
//                Text(label)
//            }
//        }
//    }
//    func signOut() {
//        print("Signing out... ")
//        currentUser = UserInfo(username:"", emailaddress:"")
//        GIDSignIn.sharedInstance().signOut()
//        let firebaseAuth = Auth.auth()
//        do {
//            try firebaseAuth.signOut()
//        } catch let signOutError as NSError {
//            print("Error signing out of Firebase: %@", signOutError)
//            return
//        }
//        print("Signed out of Firebase and Google!")
//    }
//}

// You only need this if your using the "button()" methodology of calling the google signin process
//struct SocialLogin: UIViewRepresentable {
//
//    func makeUIView(context: UIViewRepresentableContext<SocialLogin>) -> UIView {
//        return UIView()
//    }
//
//    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<SocialLogin>) {
//    }
//
//    func attemptLoginGoogle() {
//        GIDSignIn.sharedInstance()?.presentingViewController = UIApplication.shared.windows.last?.rootViewController
//        GIDSignIn.sharedInstance()?.signIn()
//    }
//
//}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
