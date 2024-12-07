//
//  RegisterViewModel.swift
//  Learn Connect
//
//  Created by Omer on 6.12.2024.
//

import Foundation

final class RegisterViewModel {
     
    init() {
//        print(DatabaseManager.shared.fetchAllUsers())
        
//        DatabaseManager.shared.insertUser(email: "john.doe@example.com", password: "password123", name: "John", surname: "Doe") { success in
//            print(success ? "User added successfully." : "Failed to add user.")
//        }

    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z.-_%+]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }

    func isPasswordValid(password: String) -> Bool {
        if password.count < 6 {
            
            return false
        }
        return true
    }
    
    func isPasswordCorrect(p1:String, p2: String) -> Bool {
        if p1 == p2 {
            return true
        }
        return false
    }
    
    func registerUser(email: String, password: String, name: String, surname: String,
                    isSuccess: (Bool) -> () ){
         
       DatabaseManager.shared.insertUser(email: email, password: password, name: name, surname: surname, isSuccess: isSuccess)
        
    }
}
