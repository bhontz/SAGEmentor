//
//  HomeView.swift
//  SAGEmentor
//
//  Created by brad.hontz on 1/28/20.
//  Copyright © 2020 brad.hontz. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    @Binding var god: String
    var body: some View {
        VStack(spacing: 10) {
            //Text("Today I will:")
            Image("morning")
                .resizable()
                .scaledToFit()
                .frame(width:400, height:80)
                .offset(y: 10)
            Text(god)
                .font(.title)
            HStack(spacing: 20) {
                NavigationLink(destination:ToDoView()) {
                    Image("greenbutton")
                        .renderingMode(.original)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                }.offset(x: 10)
                Text("To Do")
                Spacer()
            }
            HStack(spacing: 20) {
                Spacer()
                Text("Stress Relief")
                Button(action: {
                    print("pressed the button!")
                }) {
                    Image("redbutton")
                        .renderingMode(.original)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                }.offset(x: -10)
            }
            HStack(spacing: 20) {
                Button(action: {
                    print("pressed the button!")
                }) {
                    Image("greenbutton")
                        .renderingMode(.original)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                }.offset(x: 10)
                Text("Schedule")
                Spacer()
            }
            HStack(spacing: 20) {
                Spacer()
                Text("Trackers")
                Button(action: {
                    print("pressed the button!")
                }) {
                    Image("redbutton")
                        .renderingMode(.original)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                }.offset(x: -10)
            }
            HStack(spacing: 20) {
                Button(action: {
                    print("pressed the button!")
                }) {
                    Image("greenbutton")
                        .renderingMode(.original)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                }.offset(x: 10)
                Text("Snacks")
                Spacer()
            }
            Spacer()
        }
        .navigationBarTitle("Home", displayMode: .inline)
    }
}

// example of how to make a preview work with an argument
struct HomeView_Previews: PreviewProvider {
    struct BindingTestHolder: View {
        @State var testItem: String = "test"
        var body: some View {
            HomeView(god: $testItem)
        }
    }
    static var previews: some View {
        BindingTestHolder()
    }
}
