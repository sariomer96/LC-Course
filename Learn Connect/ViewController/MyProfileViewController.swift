//
//  MyProfileViewController.swift
//  Learn Connect
//
//  Created by Omer on 7.12.2024.
//

import UIKit

class MyProfileViewController: UIViewController {

    @IBOutlet weak var switchMode: UISwitch!
    override func viewDidLoad() {
        super.viewDidLoad()
        let isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")
           let window = UIApplication.shared.windows.first
           window?.overrideUserInterfaceStyle = isDarkMode ? .dark : .light

           // Switch'in durumunu ayarla
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

         // Switch durumunu kaydet
         UserDefaults.standard.set(sender.isOn, forKey: "isDarkMode")

    }
    
}
