//
//  GlobalData.swift
//  SAGEmentor
//
//  Created by brad.hontz on 1/24/20.
//  Copyright © 2020 brad.hontz. All rights reserved.
//

import Foundation
import Firebase

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

