//
//  AppDelegate.swift
//  SAGEmentor
//
//  Created by brad.hontz on 1/24/20.
//  Copyright © 2020 brad.hontz. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
                
//        // go out and check to see if you have a saved user and try to authenticate with that
//        if let currentUser = self.getObject(fileName: "currentUserId") as? UserInfo {
//            print("I recovered: \(currentUser.userName ?? "bogus") \(currentUser.emailAddress ?? "bogus")")
//
//            let firebaseAuth = Auth.auth()
//            firebaseAuth.signIn(with: (currentUser.userCredential ?? nil)!) { (result, error) in
//                if error == nil {
//                    print("already had a stored login:")
//                    print(result?.user.email)
//                    print(result?.user.displayName)
//                    print(result?.user.metadata.creationDate)
//                    print(result?.user.metadata.lastSignInDate)
//                } else {
//                    print(error?.localizedDescription)
//                }
//            }
//        }
            
        return true
    }

    // this gets called when the Google SignIn button is pressed ...
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print(error.localizedDescription)
            return
        } else {
            guard let authentication = user.authentication else {return}
            let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
            let firebaseAuth = Auth.auth()
            firebaseAuth.signIn(with: credential) { (result, error) in
                if error == nil {
                    guard let un = result?.user.displayName else {return}
                    guard let em = result?.user.email else {return}
                    currentUser = UserInfo(username: un, emailaddress: em)
//
//                    if self.saveObject(fileName: "currentUserId", object: currentUser) {
//                        print("saved log in credentials")
//                    } else {
//                        print("error saving log in credentials")
//                    }
                    
                    print(result?.user.email)
                    print(result?.user.displayName)
                    print(result?.user.metadata.creationDate)
                    print(result?.user.metadata.lastSignInDate)
                    
                } else {
                    print(error?.localizedDescription)
                }
            }
        }
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url)
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

}

// you can just add this extension to save, get and delete an object to local storage
extension UIApplicationDelegate {
    
    // Save object in document directory
    func saveObject(fileName: String, object: Any) -> Bool {
        
        let filePath = self.getDirectoryPath().appendingPathComponent(fileName)//1
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: object, requiringSecureCoding: false)
            try data.write(to: filePath)
            return true
        } catch {
            print("error is: \(error.localizedDescription)")
        }
        return false
    }
    
    // Get object from document directory
    func getObject(fileName: String) -> Any? {
        
        let filePath = self.getDirectoryPath().appendingPathComponent(fileName)
        do {
            let data = try Data(contentsOf: filePath)
            let object = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data)
            return object
        } catch {
            print("error is: \(error.localizedDescription)")
        }
        return nil
    }
    
    func removeObjectFolder(fileName: String) -> Bool {
        let fileManager = FileManager.default
        let filePath = self.getDirectoryPath().appendingPathComponent(fileName)
        do {
            if fileManager.fileExists(atPath: filePath.absoluteString) {
                print("file doesn't exist")
                return false
            } else {
                try fileManager.removeItem(at: filePath)
            }
        } catch {
            print("Something weird happened")
            return false
        }
        return true
    }
    
    //Get the document directory path
    func getDirectoryPath() -> URL {
        let arrayPaths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return arrayPaths[0]
    }
    
    //  * * * HERE IS SOME EXAMPLE USAGE * * *
    //                let userCurrent = UserInfo(username: "Brad Hontz", emailaddress: "brad.hontz@pinpointview.com")
    //
    //                if self.saveObject(fileName: "currentUserId", object: userCurrent) {
    //                    print("saved")
    //                } else {
    //                    print("error saving")
    //                }

    //        // This is the way you can delete the file/folder we created if you want to clean stuff up
    //                if self.removeObjectFolder(fileName: "currentUserId")  {
    //                    print("file was deleted")
    //                } else {
    //                    print("file was not deleted")
    //                }

    //                if let newValue = self.getObject(fileName: "currentUserId") as? UserInfo {
    //                    print("I recovered: \(newValue.userName ?? "bogus") \(newValue.emailAddress ?? "bogus")")
    //                }
    
}

