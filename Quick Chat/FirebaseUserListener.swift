//
//  FirebaseUserListener.swift
//  FirebaseUserListener
//
//  Created by Archit Patel on 2021-10-12.
//

import Foundation
import Firebase

class FirebaseUserListener {
    
    static let shared = FirebaseUserListener()
    
    private init() {}
    
    //MARK: - Login
    
    func loginUserWithEmail(email: String, password: String, compeltion: @escaping(_ error: Error?, _ isEmailVerified: Bool) -> Bool) {
        
        Auth.auth().signIn(withEmail: email, password: password) { authDataResult, error in
            
            if error == nil && authDataResult!.user.isEmailVerified {
                FirebaseUserListener.shared.downloadUserFromFirebase(userId: authDataResult!.user.uid, email: email)
                
                compeltion(error, true)
            } else {
                print("email is not verified")
                compeltion(error,false)
            }
        }
    }
    
    
    //MARK: - Register
    
    func registerUserWith(email: String, password: String, completion: @escaping(_ error: Error?) -> Void) {
        
        Auth.auth().createUser(withEmail: email, password: password) { authDataResult, error in
            completion(error)
            
            if error == nil {
                
                //send verification email
                authDataResult!.user.sendEmailVerification { error in
                    print("auth email end with error: ", error?.localizedDescription)
                }
                
                //create user and save it
                if authDataResult?.user != nil {
                    let user = User(id: authDataResult!.user.uid, username: email, email: email, pushId: "", avatarLink: "", status: "Hey there I'm using Messenger")
                    
                    saveUserLocally(user)
                    self.saveUserToFirestore(user)
                }
            }
        }
    }
    
    //MARK: - Resend link methods
    
    func resendVerificationEmail(email: String, completion: @escaping(_ error: Error?) -> Void) {
        
        Auth.auth().currentUser?.reload(completion: { error in
            Auth.auth().currentUser?.sendEmailVerification(completion: { error in
                completion(error)
            })
        })
    }
    
    func resetPasswordFor(email: String, completion: @escaping(_ error: Error?) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            completion(error)
        }
    }
    
    //MARK: - Save users
    
    func saveUserToFirestore(_ user: User) {
        
        do{
            
            try FirebaseReference(.User).document(user.id).setData(from: user)
            
        }catch{
            print(error.localizedDescription, "adding user")
        }
    }
    
    //MARK: - Download
    
    func downloadUserFromFirebase(userId: String, email: String? = nil) {
        
        FirebaseReference(.User).document(userId).getDocument { snapshot, error in
            
            guard let document = snapshot else {
                print("No document from user")
                return
            }
            
            let result  = Result {
                try? document.data(as: User.self)
            }
            
            switch result {
            case .success(let userObject):
                if let user = userObject {
                    saveUserLocally(user)
                } else {
                    print("Document does not exits")
                }
            case .failure(let error):
                print("Error decoding user", error)
            }
        }
    }
}
