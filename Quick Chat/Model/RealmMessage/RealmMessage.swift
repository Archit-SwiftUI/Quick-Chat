//
//  RealmMessage.swift
//  RealmMessage
//
//  Created by Archit Patel on 2021-10-16.
//

import Foundation
import RealmSwift

class RealmManager {
    
    static let shared = RealmManager()
    let realm = try! Realm()
    
    private init(){}
    
    func saveToRealm<T: Object>(_ object: T) {
        
        do{
            try realm.write({
                realm.add(object, update: .all)
//                realm.delete(object)
            })
        } catch {
            print("Error saving realm object")
        }
    }
    
}
