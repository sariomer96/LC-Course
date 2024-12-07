//
//  MyProfileViewController.swift
//  Learn Connect
//
//  Created by Omer on 7.12.2024.
//

import UIKit

class MyProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func clickedExit(_ sender: Any) {
        performSegue(withIdentifier: "toLoginVC", sender: nil)
    }
    

}
