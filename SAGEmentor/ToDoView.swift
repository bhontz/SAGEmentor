//
//  ToDoView.swift
//  SAGEmentor
//
//  Created by brad.hontz on 1/31/20.
//  Copyright © 2020 brad.hontz. All rights reserved.
//

import SwiftUI
import Firebase

class observeToDo: ObservableObject {
    @Published var todoList = [ToDo]()
    
    init(username: String) {
        var ref: DatabaseReference!
        ref = Database.database().reference(withPath: username + "/todo")
        ref.observe(DataEventType.value) {(snapshot) in
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                    let td = ToDo(snapshot: snapshot) {
                    self.todoList.append(td)
                }
            }
        }  // note you don't need this closing ) if you use the commented out line
    }
}

struct ToDo {
    var ref: DatabaseReference?
    var key: String
    var text: String
    var datetime: String
    var urgency: Int
    var completed: Int
    
    init(text: String, datetime: String, urgency: Int, completed: Int, key: String="") {
        self.ref = nil
        self.key = key
        self.text = text
        self.datetime = datetime
        self.urgency = urgency
        self.completed = completed
    }
    
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: AnyObject],
            let text = value["text"] as? String,
            let datetime = value["datetime"] as? String,
            let urgency = value["urgency"] as? Int,
            let completed = value["completed"] as? Int
            else {
                return nil
            }
        self.ref = snapshot.ref
        self.key = snapshot.key
        self.text = text
        self.datetime = datetime
        self.urgency = urgency
        self.completed = completed
    }
    
    func returnStuff()->Any {
        return [
            "text": text,
            "datetime": datetime,
            "urgency": urgency,
            "completed": completed
        ]
    }
}

struct ToDoView: View {
    @State private var newToDoItem = ""
    @ObservedObject var tdList = observeToDo(username:"bradhontzpinpointviewcom")
        
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Add an item:")) {
                    HStack{
                        TextField("New Item", text: self.$newToDoItem)
                        Button(action: {
                            self.tdList.todoList = []
                            self.addToDo(username: "bradhontzpinpointviewcom", text: self.newToDoItem)
                            self.newToDoItem = ""
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.green)
                                .imageScale(.large)
                        }
                    }
                }
                .font(.headline)
                
                Section(header: Text("Your ToDos:")) {
                    ForEach(self.tdList.todoList, id: \.key) { todo in
                        Text(todo.text)
                    }.onDelete{indexSet in
                        let deleteItem = self.tdList.todoList[indexSet.first!]
                        self.removeToDo(username:"bradhontzpinpointviewcom", key:deleteItem.key)
                        self.tdList.todoList = []
                    }
                }
            }
        }
        .navigationBarTitle("To Do")
//        .navigationBarItems(trailing: EditButton())
    }
    
    func removeToDo(username: String, key: String) {
        var ref: DatabaseReference!
        
        ref = Database.database().reference(withPath: username + "/todo/" + key)
        
        ref.removeValue() {
            (error:Error?, ref:DatabaseReference) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func addToDo(username: String, text: String) {
        var ref: DatabaseReference!
        
        ref = Database.database().reference(withPath: username + "/todo")
        guard let key = ref.childByAutoId().key else { return }

        // self.getDateTimeStamp()
        let tdItem = ToDo(text: text, datetime: self.getDateTimeStamp(), urgency: 0, completed: 0, key: "")

        let childUpdates = ["\(key)" : tdItem.returnStuff()]
        
        ref.updateChildValues(childUpdates) {
            (error:Error?, ref:DatabaseReference) in
            if let error = error {
                print(error.localizedDescription)
            }
        }

    }
    
    func getDateTimeStamp() -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")  // could modify this for local time zone
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        
        return dateFormatter.string(from: date).appending("Z")
    }
}

struct ToDoView_Previews: PreviewProvider {
    static var previews: some View {
        ToDoView()
    }
}
