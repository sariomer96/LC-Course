
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
        performSegue(withIdentifier: wishListViewModel.wishListViewId, sender: course)
    }
  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == wishListViewModel.wishListViewId {
               if let destinationVC = segue.destination as? CourseDetailViewController,
                 let course = sender as? MyCourse {
           
                   let imageUrl =   course.imageUrl
                  destinationVC.configure(with: imageUrl)
                  destinationVC.setCourseName(title: course.title ?? "Kurs Adi")
 
              }
          }
    }
  
} 
extension WishListViewController: UITabBarControllerDelegate {
   
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if viewController == self {
            wishListViewModel.getAllMyCourse()
            tableView.reloadData()
 
        }
   }
}

