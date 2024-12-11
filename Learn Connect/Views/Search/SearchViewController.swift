
import UIKit

class SearchViewController: UIViewController  {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!

     var searchViewModel = SearchViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(WishListTableViewCell.nib(), forCellReuseIdentifier:
                            WishListTableViewCell.identifier)
          
        searchViewModel.getAllCourse()
          
    }
    
    
 

}


extension SearchViewController: UITabBarDelegate,UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        searchViewModel.filteredHits.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        
        let cell = tableView.dequeueReusableCell(withIdentifier: WishListTableViewCell.identifier,for: indexPath) as! WishListTableViewCell
        let course = searchViewModel.filteredHits[indexPath.row]
   
        cell.courseLabel?.text = course.title
        cell.configure(with: course.videos?.medium?.thumbnail)
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let course =  searchViewModel.filteredHits[indexPath.row]
           performSegue(withIdentifier: "toCourseDetailVC", sender: course)
    }
  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCourseDetailVC" {
              if let destinationVC = segue.destination as? CourseDetailViewController,
                 let course = sender as? Hit {
                     
                 let imageUrl =   course.videos?.medium?.thumbnail
                  destinationVC.configure(with: imageUrl)
                  destinationVC.setCourseName(title: course.title ?? "Kurs Adi")
                  destinationVC.courseDetailViewModel.course = course
              }
          }
    }
    
}


extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            if searchText.isEmpty {
                // Tüm sonuçları göster
                searchViewModel.filteredHits = searchViewModel.courseContent?.hits ?? []
            } else {
                // Arama yap
                searchViewModel.filteredHits = searchViewModel.searchFilter(query: searchText)
            }
        UIView.transition(with: tableView, duration: 0.5, options: .transitionCrossDissolve, animations: {
            self.tableView.reloadData()
        }, completion: nil)
        }
}
