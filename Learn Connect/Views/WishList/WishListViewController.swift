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
        tableView.register(WishListTableViewCell.nib(), forCellReuseIdentifier:
                            WishListTableViewCell.identifier)
 
            if let tabBarController = self.tabBarController {
                tabBarController.delegate = self
            }
        
        wishListViewModel.getAllMyCourse()
        tableView.reloadData()
    }
    

 

}

extension WishListViewController : UITableViewDataSource {
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
    
   
  
}


extension WishListViewController: UITabBarControllerDelegate {
    // Tab bar değişikliklerini dinleme
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if viewController == self {
            wishListViewModel.getAllMyCourse()
            tableView.reloadData()
            print("secildi")
        }
   }
}

