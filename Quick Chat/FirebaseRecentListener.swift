//
//  FirebaseRecentListener.swift
//  FirebaseRecentListener
//
//  Created by Archit Patel on 2021-10-15.
//

import Foundation
import Firebase


class FirebaseRecentListener {
    
    static let shared = FirebaseRecentListener()
    
    private init(){}
    
    func downloadRecentChatsFromFireStore(completion: @escaping(_ allRecents: [RecentChat]) -> Void) {
        FirebaseReference(.Recent).whereField(kSENDERID, isEqualTo: User.currentId).addSnapshotListener { snapshot, error in
            var recentChats : [RecentChat] = []
            
            guard let documents = snapshot?.documents else {
                print("No document for recent chat")
                return
            }
            
            let allRecent = documents.compactMap { (snapshot) -> RecentChat? in
                return try? snapshot.data(as: RecentChat.self)
                
            }
            
            for recent in allRecent {
                if recent.lastMessage != "" {
                    recentChats.append(recent)
                }
            }
            
            recentChats.sorted(by: {$0.date! > $1.date!})
            completion(recentChats)
        }
    }
    
    func resetRecentCounter(chatRoomId: String) {
        
        FirebaseReference(.Recent).whereField(KCHATROOMID, isEqualTo: chatRoomId).whereField(kSENDERID, isEqualTo: User.currentId).getDocuments { snapshot, error in
            
            guard let documets = snapshot?.documents else {
                print("no documents for recent")
                return
            }
            
            let allRecents = documets.compactMap {(queryDocumentSnapshot) -> RecentChat? in
                
                return try? queryDocumentSnapshot.data(as: RecentChat.self)
            }
            
            if allRecents.count > 0 {
                self.clearUnreadCounter(recent: allRecents.first!)
            }
        }
    }
    
    func clearUnreadCounter(recent: RecentChat) {
        
        var newRecent = recent
        newRecent.unreadCounter = 0
        self.saveRecent(newRecent)
    }
    
    func saveRecent(_ recent: RecentChat) {
        
        do {
            try FirebaseReference(.Recent).document(recent.id).setData(from: recent)
        } catch {
            print("Error saving recent chat")
        }
    }
    
    func deleteRecent(_ recent: RecentChat) {
        
        FirebaseReference(.Recent).document(recent.id).delete()
    }
}
