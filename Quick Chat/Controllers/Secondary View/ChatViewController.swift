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

        
    }
    

}
