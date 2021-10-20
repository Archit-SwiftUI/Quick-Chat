//
//  UserTableViewCell.swift
//  UserTableViewCell
//
//  Created by Archit Patel on 2021-10-14.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
      
    }
    
    func configure(user: User) {
        usernameLabel.text = user.username
        statusLabel.text = user.status
        setAvatar(avatarLink: user.avatarLink)
    }
    
    private func setAvatar(avatarLink: String) {
        
        if avatarLink != "" {
            
            FileStorage.downloadImage(imageUrl: avatarLink) { image in
                self.avatarImageView.image = image?.circleMasked
            }
        } else {
            
            self.avatarImageView.image = UIImage(named: "avatar")
        }
        
    }

}
