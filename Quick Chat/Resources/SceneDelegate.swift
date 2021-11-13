//
//  SceneDelegate.swift
//  Quick Chat
//
//  Created by Archit Patel on 2021-10-10.
//

import UIKit
import FirebaseAuth


class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var authListener: AuthStateDidChangeListenerHandle?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        autoLogin()
        restBudge()
        
        guard let _ = (scene as? UIWindowScene) else { return }
        
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        restBudge()
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        
        LocationManager.shared.startUpdating()
        restBudge()
        
    }

    func sceneWillResignActive(_ scene: UIScene) {
        
        LocationManager.shared.stopUpdating()
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
        restBudge()
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
       
        LocationManager.shared.stopUpdating()
        restBudge()
        
    }
    
    //MARK: - AutoLogin
    
    func autoLogin() {
        authListener = Auth.auth().addStateDidChangeListener({ auth, user in
            Auth.auth().removeStateDidChangeListener(self.authListener!)
            
            if user != nil  &&  userDefaults.object(forKey: kCURRENTUSER) != nil {
                
                DispatchQueue.main.async {
                    self.goToApp()
                }
            }
        })
    }
    
    private func goToApp() {
        let mainView = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainApp") as! UITabBarController
        
        self.window?.rootViewController = mainView
    }
    
    private func restBudge() {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }

}

