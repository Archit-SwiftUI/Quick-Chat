//
//  ChatViewController.swift
//  ChatViewController
//
//  Created by Archit Patel on 2021-10-15.
//

import UIKit
import MessageKit
import InputBarAccessoryView
import Gallery
import RealmSwift

class ChatViewController: MessagesViewController {
    
    //MARK: - Variable
    private var chatId = ""
    private var recpientId = ""
    private var recpientName = ""
    
    let currentUser = MKSender(senderId: User.currentId, displayName: User.currentUser!.username)
    
    let refreshController = UIRefreshControl()
    
    let micButton = InputBarButtonItem()
    
    let mkMessages: [MKMessage] = []
    
    var allLocalMessages: Results<LocalMessage>!
    
    let realm = try! Realm()
    
    //Listeners
    
    var notificationToken: NotificationToken?
    
    //MARK: - Init
    
    init(chatId: String, recpientId: String, recpientName: String) {
        
        super.init(nibName: nil, bundle: nil)
        
        self.chatId = chatId
        self.recpientId = recpientId
        self.recpientName = recpientName
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureMessageInputBar()
        configureMessageCollectionView()
    }
    
    
    //MARK: - Configuratioin
    
    private func configureMessageCollectionView() {
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messageCellDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messagesLayoutDelegate = self
        
        scrollsToBottomOnKeyboardBeginsEditing = true
        maintainPositionOnKeyboardFrameChanged = true
        messagesCollectionView.refreshControl = refreshController
        
    }
    
    private func configureMessageInputBar() {
        
        messageInputBar.delegate = self
        
        let attachButton = InputBarButtonItem()
        attachButton.image = UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
        attachButton.setSize(CGSize(width: 30, height: 30), animated: false)
        
        attachButton.onTouchUpInside { item in
            print("attach button is pressed")
        }
        
        micButton.image = UIImage(systemName: "mic.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
        micButton.setSize(CGSize(width: 30, height: 30), animated: false)
        
        //add gesture recognizer
        
        messageInputBar.setStackViewItems([attachButton], forStack: .left, animated: false)
        messageInputBar.setLeftStackViewWidthConstant(to: 36, animated: false)
        
        messageInputBar.inputTextView.isImagePasteEnabled = false
        messageInputBar.backgroundView.backgroundColor = .systemBackground
        messageInputBar.inputTextView.backgroundColor = .systemBackground
    }
    
    
    //MARK: - Load Chats
    
    private func loadChats() {
        
        let predicate = NSPredicate(format: "chatRoomId = %@", chatId)
        
        allLocalMessages = realm.objects(LocalMessage.self).filter(predicate).sorted(byKeyPath: kDATE, ascending: true)
        
        notificationToken = allLocalMessages.observe ({(changes: RealmCollectionChange) in
            
            switch changes {
            case .initial:
                print("we have \(self.allLocalMessages.count) messages ")
                
            case .update(_, _, let insertions, _):
                
                for index in insertions {
                    print("new message\(self.allLocalMessages[index]) messages ")

                }
            case .error(let error):
                print("Error on new insertion", error.localizedDescription)
            }
        })
    }
    
    //MARK: - Actions
    
    func messageSend(text: String?, photo: UIImage?, video: String?, audio: String?, location: String?, audioDescription: Float = 0.0) {
        
        OutgoingMessage.send(chatId: chatId, text: text, photo: photo, video: video, audio: audio, location: location, memberIds: [User.currentId, recpientId ])
    }
}



