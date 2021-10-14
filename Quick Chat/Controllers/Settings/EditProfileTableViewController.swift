//
//  EditProfileTableViewController.swift
//  EditProfileTableViewController
//
//  Created by Archit Patel on 2021-10-13.
//

import UIKit
import Gallery
import ProgressHUD

class EditProfileTableViewController: UITableViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var avaterImageView: UIImageView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var usernameTextfield: UITextField!
    
    //MARK: - Variables
    var gallery: GalleryController!
    
    //MARK: - ViewLifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        configureTextField()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        showUserInfo()
    }

    //MARK: - IBActions
    
    @IBAction func editButtonPressed(_ sender: UIButton) {
        
        showImageGallery()
        
    }
    //MARK: - Tableview Delegate
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor(named: "tableviewBackgroundColor")
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0.0 : 30.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 1 && indexPath.row == 0 {
            performSegue(withIdentifier: "editProfileToStatusSeg", sender: self)
        }
    }
    
    //MARK: - UpdateUI
    
    private func showUserInfo() {
        
        if let user = User.currentUser {
            usernameTextfield.text = user.username
            statusLabel.text = user.status
            
            if user.avatarLink != "" {
                FileStorage.downloadImage(imageUrl: user.avatarLink) { image in
                    self.avaterImageView.image = image?.circleMasked
                }
            }
        }
    }
    
    //MARK: - configure
    
    private func configureTextField() {
        usernameTextfield.delegate = self
        usernameTextfield.clearButtonMode = .whileEditing
    }
    
    //MARK: - Gallery
    
    private func showImageGallery() {
        self.gallery = GalleryController()
        self.gallery.delegate = self
        
        Config.tabsToShow = [.imageTab, .cameraTab]
        Config.Camera.imageLimit = 1
        Config.initialTab = .imageTab
        self.present(gallery, animated: true, completion: nil)
    }
    
    //MARK: - Upload Images
    
    private func uploadAvatarImage(_ image: UIImage) {
        
        let fileDirectory = "Avatars/" + "_\(User.currentId)" + ".jpg"
        FileStorage.uploadImage(image, directory: fileDirectory) { avatarLink in
            
            if var user = User.currentUser {
                user.avatarLink = avatarLink ?? ""
                saveUserLocally(user)
                FirebaseUserListener.shared.saveUserToFirestore(user)
            }
            
            //TODO: Save image locally
            
            FileStorage.saveFileLocally(fileData: image.jpegData(compressionQuality: 1.0)! as NSData, fileName: User.currentId)
        }
        
    }
}


//MARK: - UITextFieldDelegate

extension EditProfileTableViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == usernameTextfield {
            if textField.text != "" {
                if var user = User.currentUser {
                    user.username = textField.text!
                    saveUserLocally(user)
                    
                    FirebaseUserListener.shared.saveUserToFirestore(user)
                }
            }
            textField.resignFirstResponder()
            return false
        }
        return true
    }
}

//MARK: - GalleryControllerDelegate

extension EditProfileTableViewController : GalleryControllerDelegate {
    func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
        if images.count > 0 {
            images.first!.resolve { avatarImage in
                
                if avatarImage != nil {
                    self.uploadAvatarImage(avatarImage!)
                    self.avaterImageView.image = avatarImage?.circleMasked
                    
                } else {
                    ProgressHUD.showError("Could't select image!")
                }
            }
        }
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryController(_ controller: GalleryController, didSelectVideo video: Video) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryController(_ controller: GalleryController, requestLightbox images: [Image]) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryControllerDidCancel(_ controller: GalleryController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
}
