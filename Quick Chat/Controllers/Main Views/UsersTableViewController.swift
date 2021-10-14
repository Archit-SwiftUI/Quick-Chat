//
//  UsersTableViewController.swift
//  UsersTableViewController
//
//  Created by Archit Patel on 2021-10-14.
//

import UIKit

class UsersTableViewController: UITableViewController {
    
    //MARK: - Variables
    var allUsers: [User] = []
    var filteredUsers: [User] = []
    
    let searchcontroller = UISearchController(searchResultsController: nil)
    
    //MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshControl = UIRefreshControl()
        self.tableView.refreshControl = self.refreshControl
        
        downloadUsers()
        setupSearchController()
        tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return searchcontroller.isActive ? filteredUsers.count : allUsers.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! UserTableViewCell
        
        let user = searchcontroller.isActive ? filteredUsers[indexPath.row] : allUsers[indexPath.row]
        cell.configure(user: user)
        return cell
    }
    
    //MARK: - TableViewDelegate
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor(named: "tableviewBackgroundColor")
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        5
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let  user = searchcontroller.isActive ? filteredUsers[indexPath.row] : allUsers[indexPath.row]
        
        showUserProfile(user)
    }

    //MARK: - DownloadUsers
    
    private func downloadUsers() {
        
        FirebaseUserListener.shared.downloadAllUsersFromFirebase { allUsers in
            self.allUsers = allUsers
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    //MARK: - SetupSearchController
    
    
    private func setupSearchController() {
        
        navigationItem.searchController = searchcontroller
        navigationItem.hidesSearchBarWhenScrolling = true
        
        searchcontroller.obscuresBackgroundDuringPresentation = false
        searchcontroller.searchBar.placeholder = "Search user"
        searchcontroller.searchResultsUpdater = self
        definesPresentationContext = true
        
    }
    
    private func filteredContentForSearchText(searchText: String) {
        
        filteredUsers = allUsers.filter({ (user) -> Bool in
            return user.username.lowercased().contains(searchText.lowercased())
        })
        
        tableView.reloadData()
    }
    
    //MARK: - UIScrollViewDelegate
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if self.refreshControl!.isRefreshing {
            self.downloadUsers()
            self.refreshControl!.endRefreshing()
        }
    }
    
    //MARK: - Navigation
    
    private func showUserProfile(_ user : User) {
        
        let profileView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProfileView") as! ProfileTableViewController
        
        profileView.user = user
        self.navigationController?.pushViewController(profileView, animated: true)
    }

}


extension UsersTableViewController : UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        filteredContentForSearchText(searchText: searchController.searchBar.text!)
        
    }
    
    
}
