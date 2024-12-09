//
//  SearchViewController.swift
//  Learn Connect
//
//  Created by Omer on 10.12.2024.
//

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
