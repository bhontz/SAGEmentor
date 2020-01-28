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
        VStack {
            Text("Today I will:")
            Divider()
            Text(god)
        }
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
