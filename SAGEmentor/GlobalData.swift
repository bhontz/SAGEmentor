//
//  GlobalData.swift
//  SAGEmentor
//
//  Created by brad.hontz on 1/24/20.
//  Copyright © 2020 brad.hontz. All rights reserved.
//

import Foundation
import Firebase

class UserInfo: NSObject, NSCoding {
    
    var userName: String?
    var emailAddress: String?
    var userCredential: AuthCredential?
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.userName, forKey:"username")
        aCoder.encode(self.emailAddress, forKey:"emailaddress")
        aCoder.encode(self.userCredential, forKey:"credential")
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.userName = aDecoder.decodeObject(forKey:"username") as? String
        self.emailAddress = aDecoder.decodeObject(forKey:"emailaddress") as? String
        self.userCredential = aDecoder.decodeObject(forKey:"credential") as? AuthCredential
    }
    
    init(username: String, emailaddress: String, credential: AuthCredential) {
        self.userName = username
        self.emailAddress = emailaddress
        self.userCredential = credential
    }
}
