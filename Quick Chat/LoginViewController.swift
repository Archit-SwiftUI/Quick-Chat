//
//  ViewController.swift
//  Quick Chat
//
//  Created by Archit Patel on 2021-10-10.
//

import UIKit
import ProgressHUD

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
            //login or register
            print("have data for login/reg")
            
        } else {
            ProgressHUD.showFailed("All Fields are required")
        }
    }
    
    @IBAction func forgetPasswordButtonPressed(_ sender: Any) {
        
        if isDataInputedFor(type: "password") {
            //reset password
            print("Have data for forget password.")
            
        } else {
            ProgressHUD.showFailed("Email is required.")
        }
    }
    
    @IBAction func resendEmailButtonPressed(_ sender: Any) {
        
        if isDataInputedFor(type: "password") {
            //resend verification email
            print("Have data for resend email")
            
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
    
    
}

