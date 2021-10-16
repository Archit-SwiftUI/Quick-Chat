//
//  MessageDataSource.swift
//  MessageDataSource
//
//  Created by Archit Patel on 2021-10-16.
//

import Foundation
import MessageKit

extension ChatViewController: MessagesDataSource {
    
    func currentSender() -> SenderType {
        return currentUser
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return mkMessages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return mkMessages.count
    }
    
}

