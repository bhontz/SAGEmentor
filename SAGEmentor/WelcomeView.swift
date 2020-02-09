//
//  WelcomeView.swift
//  SAGEmentor
//
//  Created by brad.hontz on 1/26/20.
//  Copyright © 2020 brad.hontz. All rights reserved.
//

import SwiftUI
import GoogleSignIn
import Firebase

struct WelcomeView: View {
    @Binding var results : [Result]
    @State private var god: String = ""
    @EnvironmentObject var session: SessionStore

    var body: some View {
        VStack(spacing: 20) {
            timeOfDayImage()
            Text(results[0].quote)
                .font(.title)
                .multilineTextAlignment(.center)
                .lineLimit(nil)
                .padding(.horizontal, 10.0)
            Divider()
            Text("Today I will:")
            TextField("Today's Goal", text: $god)
                .font(.title)
                .multilineTextAlignment(.center)
                .lineLimit(nil)
                .padding()
            Divider()
            NavigationLink(destination: HomeView(god: $god)) {
                Text("Home View")
            }
            .buttonStyle(GradientBackgroundStyle())
            // next up is a navigation link to the home screen
        }
        // .navigationBarTitle("Home", displayMode: .automatic)
        // I don't think you need this as this really is the first view
    }
    
    func timeOfDayImage() -> Image {
        let date = Date()
        let calendar = Calendar.current
        let currentHour = calendar.component(.hour, from: date)
        
        switch currentHour {
            case 0..<12:
                return Image("morning")
            case 12..<17:
                return Image("afternoon")
            case 17...24:
                return Image("evening")
            default:
                return Image("morning")
        }
    }

    func signOut() {
        print("Signing out... ")
        GIDSignIn.sharedInstance().signOut()
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print("Error signing out of Firebase: %@", signOutError)
            return
        }
        print("Signed out of Firebase and Google!")
        self.session.unbind()
    }
}

struct GradientBackgroundStyle: ButtonStyle {
 
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .frame(minWidth: 0, maxWidth: .infinity)
            .padding()
            .foregroundColor(.white)
            .background(LinearGradient(gradient: Gradient(colors: [.yellow, .green]), startPoint: .leading, endPoint: .trailing))
            .cornerRadius(40)
            .padding(.horizontal, 20)
    }
}

// example of how to make a preview work with an argument
struct WelcomeView_Previews: PreviewProvider {
    struct BindingTestHolder: View {
        @State var testItem: [Result] = [Result(date: "test", quote: "test")]
        var body: some View {
            WelcomeView(results: $testItem)
        }
    }
    static var previews: some View {
        BindingTestHolder()
    }
}
