//
//  LoginViewController.swift
//  PhotoApp
//
//  Created by Christopher Ching on 2018-05-30.
//  Copyright © 2018 Christopher Ching. All rights reserved.
//

import UIKit
import FirebaseUI

class LoginViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func loginTapped(_ sender: UIButton) {
  
        // Create a firebase auth ui object
        let authUI = FUIAuth.defaultAuthUI()
        
        // Check that it isn't nil
        if let authUI = authUI {
            
            // Create a firebase auth pre build UI View Controller
            let authViewController = authUI.authViewController()
            
            // Set the login view controller as the delegate
            authUI.delegate = self
            
            // Present it
            present(authViewController, animated: true, completion: nil)
        }
    }
    
}

extension LoginViewController: FUIAuthDelegate {
    
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        
        // Check if an error occurred
        guard error == nil else {
            print("An error has happened")
            return
        }
        
        // Get the user
        let user = authDataResult?.user
        
        // Check if user is nil
        if let user = user {
            
            // This means that we have a user, now check if they have a profile
            UserService.getUserProfile(userId: user.uid) { (u) in
                
                if u == nil {
                    // No profile, go to profile controller
                    self.performSegue(withIdentifier: Constants.Segue.profileViewController, sender: self)
                }
                else {
                    // This user has a profile, go to tab controller
                    let tabBarVC = self.storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.tabBarController)
                    
                    self.view.window?.rootViewController = tabBarVC
                    self.view.window?.makeKeyAndVisible()
                }
                
            }
            
            
            
        }
    }
    
}

