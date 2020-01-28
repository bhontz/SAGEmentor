//
//  WelcomeView.swift
//  SAGEmentor
//
//  Created by brad.hontz on 1/26/20.
//  Copyright © 2020 brad.hontz. All rights reserved.
//

import SwiftUI

struct WelcomeView: View {
    @Binding var results : [Result]
    @State private var god: String = ""
    @State private var pushed: Bool = false

    var body: some View {
        VStack {
            timeOfDayImage()
            Text(results[0].quote)
                .font(.title)
                .multilineTextAlignment(.center)
                .lineLimit(nil)
                .padding(.vertical, 10.0)
            Divider()
            Text("Today I will:")
            TextField("Today's Goal", text: $god)
                .font(.title)
                .multilineTextAlignment(.center)
                .lineLimit(nil)
                .padding()
            Divider()
            Button("Home View") {
                self.pushed.toggle()
            }
            .buttonStyle(GradientBackgroundStyle())
            NavigationLink(destination: ToHomeView(pushed: $pushed, god: $god), isActive: $pushed) { EmptyView() }
            // next up is a navigation link to the home screen
        }
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
}

struct ToHomeView: View {
    @Binding var pushed: Bool
    @Binding var god : String
    var body: some View {
        HomeView(god: $god)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: BackToWelcome(label:"Back") {
                self.pushed = false
            })
    }
}

struct BackToWelcome: View {
    let label: String
    let closure: () -> ()

    var body: some View {
        Button(action: { self.closure() }) {
            HStack {
                Image(systemName: "chevron.left")
                Text(label)
            }
        }
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
