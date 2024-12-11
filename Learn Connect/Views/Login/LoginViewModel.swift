
import Foundation

 class LoginViewModel {
    
    let userMail = "userEmail"
    let userPassword = "userPassword"
    let isRemember = "isRemembered"
    func login(email:String, password:String,success: @escaping (Bool) -> () ) {
        DatabaseManager.shared.loginUser(email: email, password: password, isSuccess: success)
    }
 

    func saveUserCredentials(email: String, password: String) {
        UserDefaults.standard.set(email, forKey: userMail)
        UserDefaults.standard.set(password, forKey: userPassword)
        UserDefaults.standard.set(true, forKey: isRemember)
    }

    func removeUserCredentials() {
        
        UserDefaults.standard.removeObject(forKey: userPassword)
        UserDefaults.standard.set(false, forKey: isRemember)
    }
    
    func loadUserCredentials() -> (email: String?, password: String?) {
        if let email = UserDefaults.standard.string(forKey: userMail),
           let password = UserDefaults.standard.string(forKey: userPassword) {
            return (email, password)
        }
        return (nil, nil)
    }

}
