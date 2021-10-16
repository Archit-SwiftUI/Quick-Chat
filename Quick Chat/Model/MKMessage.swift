//
//  MKMessage.swift
//  MKMessage
//
//  Created by Archit Patel on 2021-10-16.
//

import Foundation
import MessageKit
import CoreLocation


class MKMessage: NSObject, MessageType {
    
    var messageId: String
    var kind: MessageKind
    var sentDate: Date
    var incoming: Bool
    var mkSender: MKSender
    var sender: SenderType {
        return mkSender
    }
    var senderInitials: String
        
    var status: String
    var readDate: Date
    
    init(message : LocalMessage) {
        self.messageId = message.id
        self.mkSender = MKSender(senderId: message.senderId, displayName: message.senderName)
        self.status = message.status
        self.kind  = MessageKind.text(message.message)
        
//        switch message.type {
//
//        }
        
        self.senderInitials = message.senderinitials
        self.sentDate = message.date
        self.readDate = message.date
        self.incoming = User.currentId != mkSender.senderId
    }
   
}
