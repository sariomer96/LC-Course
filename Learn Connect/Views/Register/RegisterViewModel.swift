
import Foundation

final class RegisterViewModel {
      
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
