//
//  SettingsTableViewController.swift
//  SettingsTableViewController
//
//  Created by Archit Patel on 2021-10-13.
//

import UIKit
import Firebase

class SettingsTableViewController: UITableViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var avaterImageView: UIImageView!
    @IBOutlet weak var appVersionLabel: UILabel!
    
    
    //MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = UIView()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        showUserInfo()
    }
    
    
    //MARK: - TableView Delegates
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor(named: "tableviewBackgroundColor")
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0.0 : 5.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 0 && indexPath.row == 0 {
            performSegue(withIdentifier: "settingsToEditProfileSeg", sender: self)
        }
    }
    
    
    //MARK: - IBActions

    @IBAction func tellAFriendButtonPressed(_ sender: Any) {
        
        print("tell a friend")
    }
    
    @IBAction func termAndConditionButtonPressed(_ sender: Any) {
        
        print("show t&c")
    }
    
    @IBAction func logOutButtonPressed(_ sender: Any) {
        
        FirebaseUserListener.shared.logOutCurrentUser { error in
            if error == nil {
                let loginView = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginView")
                DispatchQueue.main.async {
                    loginView.modalPresentationStyle = .fullScreen
                    self.present(loginView, animated: true, completion: nil)
                }
            }
        }
    }
    
    //MARK: - UpdateUI
    
    private func showUserInfo() {
        if let user = User.currentUser {
            usernameLabel.text = user.username
            statusLabel.text = user.status
            appVersionLabel.text = "App Version \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "")"
            
            if user.avatarLink != "" {
                FileStorage.downloadImage(imageUrl: user.avatarLink) { image in
                    self.avaterImageView.image = image?.circleMasked
                }
            }
        }
    }
}
