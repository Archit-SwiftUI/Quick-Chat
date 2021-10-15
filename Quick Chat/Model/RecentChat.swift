//
//  RecentChat.swift
//  RecentChat
//
//  Created by Archit Patel on 2021-10-15.
//

import Foundation
import FirebaseFirestoreSwift

struct RecentChat : Codable {
    
    var id = ""
    var chatRoomId = ""
    var senderId = ""
    var senderName = ""
    var receiverId = ""
    var receiverName = ""
    @ServerTimestamp var date = Date()
    var memberIds = [""]
    var lastMessage = ""
    var unreadCounter = 0
    var avatarLink = ""
    
}
