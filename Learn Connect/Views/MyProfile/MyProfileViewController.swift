

import UIKit

class MyProfileViewController: UIViewController {

    @IBOutlet weak var mailLbl: UILabel!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var switchMode: UISwitch!
    override func viewDidLoad() {
        super.viewDidLoad()
        
       let user =  UserProfile.shared.user
        let userName = " \(user!.name!)  \(user!.surname!) "
        userNameLbl.text = userName
        mailLbl.text = user?.email!
        let isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")
           let window = UIApplication.shared.windows.first
           window?.overrideUserInterfaceStyle = isDarkMode ? .dark : .light
 
        
        switchMode.isOn = isDarkMode
        // Do any additional setup after loading the view.
    }
    
    
    

    @IBAction func clickedExit(_ sender: Any) {
        performSegue(withIdentifier: "toLoginVC", sender: nil)
    }
    
    @IBAction func darkSwitch(_ sender: UISwitch) {
        let window = UIApplication.shared.windows.first
         let selectedStyle: UIUserInterfaceStyle = sender.isOn ? .dark : .light
         window?.overrideUserInterfaceStyle = selectedStyle

 
         UserDefaults.standard.set(sender.isOn, forKey: "isDarkMode")

    }
    
}
