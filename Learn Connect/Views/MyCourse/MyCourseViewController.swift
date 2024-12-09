//
//  MyCourseViewController.swift
//  Learn Connect
//
//  Created by Omer on 5.12.2024.
//

import UIKit

class MyCourseViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
     var myCourseViewModel = MyCourseViewModel()
  
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.register(MyCourseTableViewCell.nib(), forCellReuseIdentifier:
                            MyCourseTableViewCell.identifier)
        
        
        myCourseViewModel.getAllMyCourse()
        // Do any additional setup after loading the view.
    }
    

}


extension MyCourseViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myCourseViewModel.myCourses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MyCourseTableViewCell.identifier,for: indexPath) as! MyCourseTableViewCell
        
        let myCourse = myCourseViewModel.myCourses[indexPath.row]
        cell.courseLabel?.text = myCourse.title
        cell.configure(with: myCourse.imageUrl)
        return cell
    }
    
  
    
    
}
