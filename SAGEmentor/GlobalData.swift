//
//  GlobalData.swift
//  SAGEmentor
//
//  Created by brad.hontz on 1/24/20.
//  Copyright © 2020 brad.hontz. All rights reserved.
//

import Foundation
import Firebase
import Combine

// *** KEEPING THIS HERE FOR WHEN WE NEED TO ENCODE DATES!! ***
//let date = Date()
//let encoder = JSONEncoder()
//encoder.dateEncodingStrategy = .iso8601
//let data = try! encoder.encode(date)
//print(String(data: data, encoding: .utf8)!)

// *** Extend a View with this if you need to print some debugging *** //
// *** how to use this: Print("your label: ", variable)  *** //
//extension View {
//    func Print(_ vars: Any...) -> some View {
//        for v in vars { print(v) }
//        return EmptyView()
//    }
//}

class User {
    var uid: String
    var email: String?
    var displayName: String?

    init(uid: String, displayName: String?, email: String?) {
        self.uid = uid
        self.email = email
        self.displayName = displayName
    }
}

class SessionStore : ObservableObject {
    var didChange = PassthroughSubject<SessionStore, Never>()
    var session: User? { didSet { self.didChange.send(self) }}
    var handle: AuthStateDidChangeListenerHandle?
    @Published var isLoggedIn = false

    func listen () {
        // monitor authentication changes using firebase
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user {
                // if we have a user, create a new user model
                print("GOT A USER! : \(user)")
                self.isLoggedIn = true
                self.session = User(
                    uid: user.uid,
                    displayName: user.displayName,
                    email: user.email
                )
            } else {
                // if we don't have a user, set our session to nil
                self.session = nil
            }
        }
    }
    
    func unbind () {
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
}


//class UserData: ObservableObject {
//   @Published var loggedIn = false
//}

// these three structures are used for the QOD API call

struct Response: Decodable {
    var contents: Quotes
}

struct Quotes: Decodable {
    var quotes: [Result]
}

struct Result: Decodable {
    var date: String
    var quote: String
}

// this structure is for our TODO items

struct ToDoXX {
    let ref: DatabaseReference?
    let key: String
    let text: String
    let datetime: String
    let urgency: Int
    let completed: Int
    
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
    
    func toAnyObject() -> Any {
        return [
            "key": key,
            "text": text,
            "datetime": datetime,
            "urgency": urgency,
            "completed": completed,
        ]
    }
}

class ToDoStore : ObservableObject {
    @Published var toDoList:[ToDoXX] = []

    func load() {
        var ref: DatabaseReference!
        
        ref = Database.database().reference(withPath: "bradhontzpinpointviewcom/todo")
        ref.observe(DataEventType.value) {(snapshot) in
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                    let td = ToDoXX(snapshot: snapshot) {
                    self.toDoList.append(td)
                    print(td.text)
                }
            }
        }
    }
}

//extension toDos {
//    static func testLoad() -> [toDos] {
//        return [
//            toDos(text:"first one", datetime:"date0", urgency:0, completed:0, key:"0"),
//            toDos(text:"second one", datetime:"date1", urgency:0, completed:0, key:"1"),
//            toDos(text:"third one", datetime:"date2", urgency:0, completed:0, key:"2")
//        ]
//    }
//
//}


//var currentUser = UserInfo(username:"", emailaddress:"")
//
//class UserInfo: NSObject, NSCoding {
//    
//    var userName: String?
//    var emailAddress: String?
//    
//    func encode(with aCoder: NSCoder) {
//        aCoder.encode(self.userName, forKey:"username")
//        aCoder.encode(self.emailAddress, forKey:"emailaddress")
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        self.userName = aDecoder.decodeObject(forKey:"username") as? String
//        self.emailAddress = aDecoder.decodeObject(forKey:"emailaddress") as? String
//    }
//    
//    init(username: String, emailaddress: String) {
//        self.userName = username
//        self.emailAddress = emailaddress
//    }
//}

