//
//  User.swift
//  User
//
//  Created by Archit Patel on 2021-10-12.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift


struct User: Codable, Equatable {
    
    var id = ""
    var username: String
    var email: String
    var pushId = ""
    var avatarLink = ""
    var status: String
    
    static var currentId: String {
        return Auth.auth().currentUser!.uid
    }
    
    static var currentUser: User? {
        if Auth.auth().currentUser != nil {
            if let dictionary = UserDefaults.standard.data(forKey: KCURRENTUSER) {
                
                let decoder = JSONDecoder()
                
                do{
                    let userObject = try decoder.decode(User.self, from: dictionary)
                    return userObject
                    
                }catch{
                    print("Error decoding user from userDefaults", error.localizedDescription)
                }
            }
        }
        return nil
    }
    
    static func == (lhs: User, rhs: User) -> Bool {
        lhs.id == rhs.id
    }
    
}

func saveUserLocally(_ user: User) {
    
    let encoder = JSONEncoder()
    
    do{
        
        let data = try encoder.encode(user)
        UserDefaults.standard.set(data, forKey: KCURRENTUSER)
        
    }catch {
        print("Error saving user locally", error.localizedDescription)
    }
}
