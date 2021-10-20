//
//  ViewController.swift
//  Quick Chat
//
//  Created by Archit Patel on 2021-10-10.
//

import UIKit
import ProgressHUD
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    //Labels
    @IBOutlet weak var emailLabelOutlet: UILabel!
    @IBOutlet weak var passwordLabelOutlet: UILabel!
    @IBOutlet weak var repeatPasswordLabelOutlet: UILabel!
    @IBOutlet weak var signUpLabel: UILabel!
   
    
    //TextFields
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var repeatPasswordTextfield: UITextField!
    
    //Buttons
    @IBOutlet weak var loginButtonOutlet: UIButton!
    @IBOutlet weak var signUpButtonOutlet: UIButton!
    @IBOutlet weak var resentEmailButtonOutlet: UIButton!
    
    //Views
    @IBOutlet weak var repeatPasswordLineView: UIView!
    
    //MARK: - Varaible
    
    var isLogin = true
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUIFor(login: true)
        setupTextFieldDelegate()
        setupBackgroundTap()
    }
    
    //MARK: - Actions
    
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        
        if isDataInputedFor(type: isLogin ? "login" : "register") {
            isLogin ? loginUser() : registerUser()
            
        } else {
            ProgressHUD.showFailed("All Fields are required")
        }
    }
    
    @IBAction func forgetPasswordButtonPressed(_ sender: Any) {
        
        if isDataInputedFor(type: "password") {
            //reset password
            resetPassword()
            
        } else {
            ProgressHUD.showFailed("Email is required.")
        }
    }
    
    @IBAction func resendEmailButtonPressed(_ sender: Any) {
        
        if isDataInputedFor(type: "password") {
            //resend verification email
           resendVerificationEmail()
            
        } else {
            ProgressHUD.showFailed("Email is required.")
        }
    }
    
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        updateUIFor(login: sender.titleLabel?.text == "Login")
        isLogin.toggle()
        
    }
    
    
    //MARK: - Setup
    
    private func setupTextFieldDelegate() {
        emailTextfield.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        passwordTextfield.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        repeatPasswordTextfield.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    private func setupBackgroundTap(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTap))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func textFieldDidChange(_ textField : UITextField) {
        updatePlaceholderLabels(textField: textField)
    }
    
    @objc func backgroundTap() {
        view.endEditing(false)
    }
    
    
    
    //MARK: - Animations
    
    private func updateUIFor(login: Bool){
        
        loginButtonOutlet.setImage(UIImage(named: login ? "loginBtn" : "registerBtn"), for: .normal)
        signUpButtonOutlet.setTitle(login ? "Sign Up" : "Login", for: .normal)
        signUpLabel.text = login ? "Don't have an account?" : "Have a account?"
        
        UIView.animate(withDuration: 0.5) {
            self.repeatPasswordTextfield.isHidden = login
            self.repeatPasswordLabelOutlet.isHidden = login
            self.repeatPasswordLineView.isHidden = login
        }

        
    }
    
    private func updatePlaceholderLabels(textField: UITextField) {
     
        switch textField {
        case emailTextfield:
            emailLabelOutlet.text = textField.hasText ? "Email" : ""
        case passwordTextfield:
            passwordLabelOutlet.text = textField.hasText ? "Password" : ""
        default:
            repeatPasswordLabelOutlet.text = textField.hasText ? "Repeat Password" : ""
        }
    }
    
    //MARK: - Helpers
    
    private func isDataInputedFor(type : String) -> Bool {
        
        switch type {
        case "login":
            return emailTextfield.text != "" && passwordTextfield.text != ""
        case "registration":
            return emailTextfield.text != "" && passwordTextfield.text != "" && repeatPasswordTextfield.text != ""

        default:
            return emailTextfield.text != ""

        }
    }
    
    //MARK: - Register
    
    private func registerUser() {
        
        if passwordTextfield.text! == repeatPasswordTextfield.text! {
            
            FirebaseUserListener.shared.registerUserWith(email: emailTextfield.text!, password: passwordTextfield.text!) { error in
                print(self.emailTextfield.text!)
                
                if error == nil {
                    ProgressHUD.showSuccess("Verification email sent..")
                    self.resentEmailButtonOutlet.isHidden = false
                } else {
                    ProgressHUD.showFailed(error!.localizedDescription)
                }
            }
        } else {
            ProgressHUD.showFailed("The password don't match")
        }
        
    }
    
    //MARK: - Login
    
    private func loginUser() {
        
        
        FirebaseUserListener.shared.loginUserWithEmail(email: emailTextfield.text!, password: passwordTextfield.text!) { error, isEmailVerified in
            if error == nil {
                
                if isEmailVerified {
                    
                    self.goToApp()
                    
                } else {
                    ProgressHUD.showFailed("Please verify email.")
                    self.resentEmailButtonOutlet.isHidden = false

                }
            } else {
                ProgressHUD.showFailed(error!.localizedDescription)
            }
        }
    }
    
    
    private func resetPassword() {
        
        FirebaseUserListener.shared.resetPasswordFor(email: emailTextfield.text!) { error in
            if error == nil {
                ProgressHUD.showSuccess("Reset link send to email")
            } else {
                ProgressHUD.showFailed(error!.localizedDescription)
            }
        }
    }
    
    private func resendVerificationEmail(){
        FirebaseUserListener.shared.resendVerificationEmail(email: emailTextfield.text!) { error in
            if error == nil {
                
                ProgressHUD.showSuccess("New verification email sent.")
                
            } else {
                ProgressHUD.showError(error!.localizedDescription)
            }
        }
    }
    //MARK: - Navigation
    
    
    private func goToApp() {
        
        let mainView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainApp") as! UITabBarController
        mainView.modalPresentationStyle = .fullScreen
        self.present(mainView, animated: true, completion: nil)
    }
}

