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
    

}


extension MyCourseViewController : UITableViewDataSource,UITableViewDelegate {
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let myCourse = myCourseViewModel.myCourses[indexPath.row]
        
        let videoLessonVC = storyboard?.instantiateViewController(withIdentifier: "VideoLessonViewController") as! VideoLessonViewController
        videoLessonVC.videoLessonViewModel.myCourse = myCourse

        let videoLesson = storyboard?.instantiateViewController(withIdentifier: "VideoLessonViewController") as! VideoLessonViewController
        videoLesson.videoLessonViewModel.myCourse = myCourse
        
        navigationController?.pushViewController(videoLesson, animated: true)


//         performSegue(withIdentifier: "toVideoLessonVC", sender: myCourse)
    }
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toVideoLessonVC" {
               if let destinationVC = segue.destination as? VideoLessonViewController,
                 let course = sender as? MyCourse {
                  
                   destinationVC.videoLessonViewModel.setMyCourse(myCourse: course)
                   destinationVC.modalPresentationStyle = .fullScreen
//                  destinationVC.courseDetailViewModel.course = course
              }
          }
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

