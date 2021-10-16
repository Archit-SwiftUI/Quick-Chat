//
//  FirebaseMessagesListener.swift
//  FirebaseMessagesListener
//
//  Created by Archit Patel on 2021-10-16.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

class FirebaseMessageListener {
    
    static let shared = FirebaseMessageListener()
    
    private init() {}
    
    //MARK: - Add, Update, Delete,
    
    func addMessages(_ message: LocalMessage, memberId: String) {
        
        do {
            
            let _ = try FirebaseReference(.Messages).document(memberId).collection(message.chatRoomId).document(message.id).setData(from: message)
            
        } catch {
            print("error saving message")
        }
    }
}
