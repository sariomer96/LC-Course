//
//  FirstSegmentedViewController.swift
//  Learn Connect
//
//  Created by Omer on 6.12.2024.
//

import UIKit

class FirstSegmentViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
            tableView.delegate = self
            tableView.dataSource = self
            
    
    let nibName = UINib(nibName: "CourseVideosTableViewCell", bundle: nil)
    
    self.tableView.register(nibName, forCellReuseIdentifier: "CourseVideosTableViewCell")
    }
}

extension FirstSegmentViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CourseVideosTableViewCell", for: indexPath)
        as! CourseVideosTableViewCell
        return cell
    }
    
    
}
