//
//  UserService.swift
//  PhotoApp
//
//  Created by Christopher Ching on 2018-06-05.
//  Copyright © 2018 Christopher Ching. All rights reserved.
//

import Foundation
import FirebaseDatabase

class UserService {
    
    static func createUserProfile(userId:String, username:String, completion: @escaping (PhotoUser?) -> Void ) -> Void {
        
        // Create a dictionary for the user profile
        let userProfileData = ["username":username]
        
        // Get a database reference
        let ref = Database.database().reference()
        
        // Create the profile for the user id
        ref.child("users").child(userId).setValue(userProfileData) { (error, ref) in
            
            if error != nil {
                // There was an error
                completion(nil)
            }
            else {
                // Create the user and pass it back
                let u = PhotoUser(username: username, userId: userId)
                completion(u)
            }
            
        }
    }
    
    
    static func getUserProfile(userId:String, completion: @escaping (PhotoUser?) -> Void ) -> Void {
        
        // Get a database reference
        let ref = Database.database().reference()
        
        // Try to retrieve the profile for the passed in userid
        ref.child("users").child(userId).observeSingleEvent(of: .value) { (snapshot) in
            
            // Check the returned snapshot value to see if there's a profile
            if let userProfileData = snapshot.value as? [String:Any] {
                
                // This means there is a profile
                // Create a photo user with the profile details
                var u = PhotoUser()
                u.userId = snapshot.key
                u.username = userProfileData["username"] as? String
                
                // Pass it into the completion closure
                completion(u)
            }
            else {
                
                // This means there wasn't a profile
                // Return nil
                completion(nil)
            }
            
        }
        
    }
    
}
