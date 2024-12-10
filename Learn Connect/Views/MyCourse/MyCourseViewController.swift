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
        tableView.delegate = self
        tableView.register(MyCourseTableViewCell.nib(), forCellReuseIdentifier:
                            MyCourseTableViewCell.identifier)
         
        if let tabBarController = self.tabBarController {
            tabBarController.delegate = self
        }
        myCourseViewModel.getAllMyCourse()
        tableView.reloadData()
        
        
    }
    @IBAction func clickedAllCourseBtn(_ sender: UIButton) {
        myCourseViewModel.courseFilterType = .all
        myCourseViewModel.getAllMyCourse()
        UIView.transition(with: tableView, duration: 0.3, options: .transitionCrossDissolve, animations: {
               self.tableView.reloadData()
           })
       
    }
    
    @IBAction func clickedDownloadsBtn(_ sender: UIButton) {
        myCourseViewModel.courseFilterType = .downloads
        myCourseViewModel.getDownloadedCourse()
        UIView.transition(with: tableView, duration: 0.3, options: .transitionCrossDissolve, animations: {
               self.tableView.reloadData()
           })
         
    }
    
      
}


extension MyCourseViewController : UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if myCourseViewModel.courseFilterType == .all {
              return myCourseViewModel.myCourses.count
          } else if myCourseViewModel.courseFilterType == .downloads {
              print(myCourseViewModel.downloadedCourse.count)
              return myCourseViewModel.downloadedCourse.count
          } else {
              return 0
          }    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MyCourseTableViewCell.identifier,for: indexPath) as! MyCourseTableViewCell
        
        if myCourseViewModel.courseFilterType == .all {
            let myCourse = myCourseViewModel.myCourses[indexPath.row]
            cell.courseLabel?.text = myCourse.title
            cell.configure(with: myCourse.imageUrl)
            
    
            return cell
        } else {
            
            let myCourse = myCourseViewModel.downloadedCourse[indexPath.row]
         
            cell.courseLabel?.text = myCourse.title
            cell.courseImageView.image = myCourse.image
            return cell
        }
      
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let myCourse = myCourseViewModel.myCourses[indexPath.row]
        
//        print(myCourseViewModel.courseFilterType)

        let videoLesson = storyboard?.instantiateViewController(withIdentifier: "VideoLessonViewController") as! VideoLessonViewController
        videoLesson.videoLessonViewModel.myCourse = myCourse
        
        if myCourseViewModel.courseFilterType == .downloads {
            videoLesson.videoLessonViewModel.isDownloaded = true
        } else {
            videoLesson.videoLessonViewModel.isDownloaded = false
        }
       
        navigationController?.pushViewController(videoLesson, animated: true)

 
    }
   
 
    
    
}


extension MyCourseViewController: UITabBarControllerDelegate {
    // Tab bar değişikliklerini dinleme
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if viewController == self {
            myCourseViewModel.getAllMyCourse()
            tableView.reloadData()
   
        }
   }
}

