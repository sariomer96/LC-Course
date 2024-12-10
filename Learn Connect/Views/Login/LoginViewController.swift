

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
    
    func scheduleLocalNotification() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Notification permission granted.")
            } else if let error = error {
                print("Permission denied: \(error.localizedDescription)")
            }
        }
        let content = UNMutableNotificationContent()
        content.title = "Merhaba!"
        content.body = "Bu bir yerel bildirim örneğidir."
        content.sound = .default
         
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
        
        // Bildirim isteği oluştur
        let request = UNNotificationRequest(identifier: "localNotification", content: content, trigger: trigger)
        
        // Bildirimi planla
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Bildirim planlanamadı: \(error.localizedDescription)")
            } else {
                print("Bildirim planlandı!")
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
           scheduleLocalNotification()
        
        
      

        let systemImage = UIImage(systemName: "star.fill")

       var a =   DatabaseManager.shared.fetchAllDownloads()
        
      
        for download in a {
             
            let imageView = UIImageView(image: download.image)
 
        }

 
        
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
        guard let hashedPass = Helper.shared.hashPassword(password: passwordTF.text!) else { return }
        
        loginViewModel.login(email: emailTF.text!, password: hashedPass) { [weak self] isSuccess in
            guard let self = self else { return }
            
            if isSuccess {
                if let user = DatabaseManager.shared.fetchUserByEmail(email: self.emailTF.text!) {
                     
                    if let tabBarController = self.storyboard?.instantiateViewController(withIdentifier: "toTabBar") as? UITabBarController {
                        
                        if let homeVC = tabBarController.viewControllers?.first as? HomeViewController {
                            UserProfile.shared.user = user
                        }
                        
                        // NavigationController ile geçiş yap
                        if let navigationController = self.navigationController {
                            // TabBarController'ı root olarak ayarla
                            navigationController.setViewControllers([tabBarController], animated: true)
                        } else {
                            print("NavigationController bulunamadı!")
                        }
                        
                        // Eğer 'Hatırla' seçeneği aktifse kullanıcı bilgilerini kaydet
                        if self.rememberSwitch.isOn {
                            self.loginViewModel.saveUserCredentials(email: self.emailTF.text!, password: self.passwordTF.text!)
                        } else {
                            self.loginViewModel.removeUserCredentials()
                        }
                    } else {
                        print("TabBarController oluşturulamadı.")
                    }
                } else {
                    print("No user found with this email.")
                }
            } else {
                self.showAlert(message: "Geçersiz email veya parola", isSuccess: false)
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
    


