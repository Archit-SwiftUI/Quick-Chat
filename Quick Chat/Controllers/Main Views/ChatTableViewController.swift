//
//  ChatTableViewController.swift
//  ChatTableViewController
//
//  Created by Archit Patel on 2021-10-15.
//

import UIKit

class ChatTableViewController: UITableViewController {
    
    //MARK: - Variables
    var allRecents : [RecentChat] = []
    var filteredRencents : [RecentChat] = []
    
    
    let searchController = UISearchController(searchResultsController: nil)
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = UIView()
        downloadRecentChats()
        setupSearchController()
    }
    
    //MARK: - IBActions
    
    @IBAction func composeBarButtonPressed(_ sender: Any) {
     
        let userView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "usersView") as! UsersTableViewController
        
        navigationController?.pushViewController(userView, animated: true)
        
    }
    

    
    //MARK: - Table view Datasource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchController.isActive ? filteredRencents.count : allRecents.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! RecentChatTableViewCell
        
        let recent = searchController.isActive ? filteredRencents[indexPath.row]: allRecents[indexPath.row]

        
        cell.configure(recent: recent)
        
        return cell
    }
    
    //MARK: - Delegate
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            let recent = searchController.isActive ? filteredRencents[indexPath.row] : allRecents[indexPath.row]
            
            FirebaseRecentListener.shared.deleteRecent(recent)
            
            searchController.isActive ? self.filteredRencents.remove(at: indexPath.row) : self.allRecents.remove(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let headerView = UIView()
        headerView.backgroundColor = UIColor(named: "tableviewBackgroundColor")
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 5.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let recent = searchController.isActive ? filteredRencents[indexPath.row]: allRecents[indexPath.row]

        FirebaseRecentListener.shared.clearUnreadCounter(recent: recent)
        
        goToChat(recent: recent)
        
    }
    //MARK: - downloadRecentChats
    
    private func downloadRecentChats() {
        FirebaseRecentListener.shared.downloadRecentChatsFromFireStore { allChats in
            
            self.allRecents = allChats
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    //MARK: - Navigation
    
    private func goToChat(recent: RecentChat) {
        
        restartChat(chatRoomId: recent.chatRoomId, memberIds: recent.memberIds)
        
        let privateChatView = ChatViewController(chatId: recent.chatRoomId, recpientId: recent.receiverId, recpientName: recent.receiverName)
        
        privateChatView.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(privateChatView, animated: true)
        
    }

    
    //MARK: - Search Controller
    
    private func setupSearchController() {
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search user"
        searchController.searchResultsUpdater = self
        definesPresentationContext = true
        
    }
    
    
    private func filteredContentForSearchText(searchText: String) {
        
        filteredRencents = allRecents.filter({(recent) -> Bool in
            return recent.receiverName.lowercased().contains(searchText.lowercased())
        })
        
        tableView.reloadData()
    }
}

extension ChatTableViewController : UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        filteredContentForSearchText(searchText: searchController.searchBar.text!)
    }
    
    
}
