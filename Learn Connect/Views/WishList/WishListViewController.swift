//
//  WishListViewController.swift
//  Learn Connect
//
//  Created by Omer on 5.12.2024.
//

import UIKit

class WishListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var wishListViewModel = WishListViewModel()
     
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self

        tableView.register(WishListTableViewCell.nib(), forCellReuseIdentifier:
                            WishListTableViewCell.identifier)
 
            if let tabBarController = self.tabBarController {
                tabBarController.delegate = self
            }
        
        wishListViewModel.getAllMyCourse()
        tableView.reloadData()
    }
    

 

}

extension WishListViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wishListViewModel.myCourses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WishListTableViewCell.identifier,for: indexPath) as! WishListTableViewCell
        let wishList = wishListViewModel.myCourses[indexPath.row]
        cell.courseLabel?.text = wishList.title
        cell.configure(with: wishList.imageUrl)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
        let course =  wishListViewModel.myCourses[indexPath.row]
           performSegue(withIdentifier: "toCourseDetail", sender: course)
    }
  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCourseDetail" {
               if let destinationVC = segue.destination as? CourseDetailViewController,
                 let course = sender as? MyCourse {
                     print("burdaaa")
                   let imageUrl =   course.imageUrl
                  destinationVC.configure(with: imageUrl)
                  destinationVC.setCourseName(title: course.title ?? "Kurs Adi")
//                  destinationVC.courseDetailViewModel.course = course
              }
          }
    }
  
}


extension WishListViewController: UITabBarControllerDelegate {
   
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if viewController == self {
            wishListViewModel.getAllMyCourse()
            tableView.reloadData()
            print("secildi")
        }
   }
}

