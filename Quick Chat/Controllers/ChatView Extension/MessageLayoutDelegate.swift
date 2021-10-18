//
//  MessageLayoutDelegate.swift
//  MessageLayoutDelegate
//
//  Created by Archit Patel on 2021-10-16.
//

import Foundation
import MessageKit

extension ChatViewController : MessagesLayoutDelegate {
    
    //MARK: - Cell top label
    
    func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        
        if indexPath.section % 3 == 0 {
            
            if ((indexPath.section == 0) && (allLocalMessages.count > displayMessagesCount)) {
                
                
                return 40
            }
            return 18
            
        }
        
        return 0
    }
    
    func cellBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return isFromCurrentSender(message: message) ? 17 : 0

    }
    
    //MARK: - Message bottom label
    
    func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return indexPath.section != mkMessages.count - 1 ? 10 : 0
    }
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        
        avatarView.set(avatar: Avatar(initials: mkMessages[indexPath.section].senderInitials))
    }
    
}
