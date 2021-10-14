//
//  ProfileTableViewController.swift
//  ProfileTableViewController
//
//  Created by Archit Patel on 2021-10-14.
//

import UIKit

class ProfileTableViewController: UITableViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    //MARK: - Variables
    
    var user : User?
    
    //MARK: - ViewLifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never
        tableView.tableFooterView = UIView()
        
        setupUI()

    }


    //MARK: - Table View Delegate
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor(named: "tableviewBackgroundColor")
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 1 {
            print("Start chating")
        }
        
        //TODO:  Go to chatroom
    }
    //MARK: - Setup UI

    private func setupUI() {
        
        if user != nil {
            self.title = user!.username
            usernameLabel.text = user!.username
            statusLabel.text = user!.status
            
            if user?.avatarLink != "" {
                FileStorage.downloadImage(imageUrl: user!.avatarLink) { image in
                    self.avatarImageView.image = image?.circleMasked
                }
            }
        }
        
    }
}
