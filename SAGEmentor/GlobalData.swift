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

//class User {
//    var uid: String
//    var email: String?
//    var displayName: String?
//
//    init(uid: String, displayName: String?, email: String?) {
//        self.uid = uid
//        self.email = email
//        self.displayName = displayName
//    }
//}
//
//class SessionStore : ObservableObject {
//    var didChange = PassthroughSubject<SessionStore, Never>()
//    var session: User? { didSet { self.didChange.send(self) }}
//    var handle: AuthStateDidChangeListenerHandle?
//
//    func listen () {
//        // monitor authentication changes using firebase
//        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
//            if let user = user {
//                // if we have a user, create a new user model
//                print("Got user: \(user)")
//                self.session = User(
//                    uid: user.uid,
//                    displayName: user.displayName,
//                    email: user.email
//                )
//            } else {
//                // if we don't have a user, set our session to nil
//                self.session = nil
//            }
//        }
//    }
//
//    // additional methods (sign up, sign in) will go here
//}


class UserData: ObservableObject {
   @Published var loggedIn = false
}

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


var currentUser = UserInfo(username:"", emailaddress:"")

class UserInfo: NSObject, NSCoding {
    
    var userName: String?
    var emailAddress: String?
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.userName, forKey:"username")
        aCoder.encode(self.emailAddress, forKey:"emailaddress")
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.userName = aDecoder.decodeObject(forKey:"username") as? String
        self.emailAddress = aDecoder.decodeObject(forKey:"emailaddress") as? String
    }
    
    init(username: String, emailaddress: String) {
        self.userName = username
        self.emailAddress = emailaddress
    }
}

