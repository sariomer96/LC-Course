//
//  WishListViewController.swift
//  Learn Connect
//
//  Created by Omer on 5.12.2024.
//

import UIKit

class WishListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var strings:[String] = ["aajdshgksjdhgkjsghaaajdshgksjdhgkjsghaaajdshgksjdhgkjsgha","bbb","aaa","bbb"]
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.register(WishListTableViewCell.nib(), forCellReuseIdentifier:
                            WishListTableViewCell.identifier)
        // Do any additional setup after loading the view.
    }
    

   
  

}

extension WishListViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return strings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WishListTableViewCell.identifier,for: indexPath) as! WishListTableViewCell
        cell.courseLabel?.text = strings[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
          if editingStyle == .delete {
              // Veriyi kaynaktan sil
              strings.remove(at: indexPath.row)
              
              // TableView'i güncelle
              tableView.deleteRows(at: [indexPath], with: .automatic)
          }
      }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Sil") { (_, _, completionHandler) in
            // Veriyi sil
            self.strings.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            completionHandler(true)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
}
