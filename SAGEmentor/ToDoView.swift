//
//  ToDoView.swift
//  SAGEmentor
//
//  Created by brad.hontz on 1/31/20.
//  Copyright © 2020 brad.hontz. All rights reserved.
//

import SwiftUI

struct ToDoView: View {
    @State private var newToDoItem = ""
    
    var body: some View {
        NavigationView {
            List{
                Section(header: Text("My ToDos:")) {
                    HStack{
                        TextField("New Item", text: self.$newToDoItem)
                        Button(action: {
                            
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.green)
                                .imageScale(.large)
                        }
                    }
                }
            }
        }
    }
}

//struct ToDoView_Previews: PreviewProvider {
//    static var previews: some View {
//        ToDoView()
//    }
//}
