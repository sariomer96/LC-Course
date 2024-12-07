//
//  MyCourseViewController.swift
//  Learn Connect
//
//  Created by Omer on 5.12.2024.
//

import UIKit

class MyCourseViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var strings:[String] = ["aajdshgksjdhgkjsghaaajdshgksjdhgkjsghaaajdshgksjdhgkjsgha","bbb","aaa","bbb"]
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.register(MyCourseTableViewCell.nib(), forCellReuseIdentifier:
                            MyCourseTableViewCell.identifier)
        // Do any additional setup after loading the view.
    }
    

}


extension MyCourseViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return strings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MyCourseTableViewCell.identifier,for: indexPath) as! MyCourseTableViewCell
        cell.courseLabel?.text = strings[indexPath.row]
        return cell
    }
    
  
    
    
}
