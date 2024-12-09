//
//  LoginViewModel.swift
//  Learn Connect
//
//  Created by Omer on 7.12.2024.
//

import Foundation

final class LoginViewModel {
   
 
    
    
    func login(email:String, password:String,success: @escaping (Bool) -> () ) {
        DatabaseManager.shared.loginUser(email: email, password: password, isSuccess: success)
    }
 

    func saveUserCredentials(email: String, password: String) {
        UserDefaults.standard.set(email, forKey: "userEmail")
        UserDefaults.standard.set(password, forKey: "userPassword")
        UserDefaults.standard.set(true, forKey: "isRemembered")
    }

    func removeUserCredentials() {
        
        UserDefaults.standard.removeObject(forKey: "userPassword")
        UserDefaults.standard.set(false, forKey: "isRemembered")
    }
    
    func loadUserCredentials() -> (email: String?, password: String?) {
        if let email = UserDefaults.standard.string(forKey: "userEmail"),
           let password = UserDefaults.standard.string(forKey: "userPassword") {
            return (email, password)
        }
        return (nil, nil)
    }

}
