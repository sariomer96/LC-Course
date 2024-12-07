//
//  CourseDetailViewController.swift
//  Learn Connect
//
//  Created by Omer on 5.12.2024.
//

import UIKit

class CourseDetailViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
            
        tableView.delegate = self
        tableView.dataSource = self
        
        
        let nibName = UINib(nibName: "CommentTableViewCell", bundle: nil)
        
        self.tableView.register(nibName, forCellReuseIdentifier: "CommentTableViewCell")
        // Do any additional setup after loading the view.
    }
  

}

extension CourseDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell", for: indexPath) as! CommentTableViewCell
        
        return cell
    }
    
    
}

