

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var rememberSwitch: UISwitch!
    let loginViewModel = LoginViewModel()
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.hidesBackButton = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        DatabaseManager.shared
        let isRemembered = UserDefaults.standard.bool(forKey: "isRemembered")
           rememberSwitch.isOn = isRemembered
 
           if isRemembered {
               if let savedEmail = UserDefaults.standard.string(forKey: "userEmail"),
                  let savedPassword = UserDefaults.standard.string(forKey: "userPassword") {
       
                   emailTF.text = savedEmail
                   passwordTF.text = savedPassword
               }
           }
        
     
    }

    @IBAction func loginClicked(_ sender: Any) {
        guard var hashedPass = Helper.shared.hashPassword(password: passwordTF.text!) else { return  }
        
        loginViewModel.login(email: emailTF.text!, password: hashedPass) { [self] isSuccess in
            
            if isSuccess {
                    performSegue(withIdentifier: "toTabBar", sender: nil)
                 
                if rememberSwitch.isOn {
                    loginViewModel.saveUserCredentials(email: emailTF.text!, password: passwordTF.text!)
                } else {
                    loginViewModel.removeUserCredentials()
                }

            } else {
                showAlert(message: "Geçersiz email veya parola",isSuccess: false)
            }
        }
     
        }
    
    func showAlert(message: String, isSuccess: Bool = false) {
        let alert = UIAlertController(title: isSuccess ? " Başarılı" : "Hata",
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
    


