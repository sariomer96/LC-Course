//
//  FirstSegmentedViewController.swift
//  Learn Connect
//
//  Created by Omer on 6.12.2024.
//

import UIKit

class SecondSegmentViewController: UIViewController {
 
    @IBOutlet weak var tableView: UITableView!
    let textList = ["Yorum yap ve degerlendir","Favorilere ekle"]
    override func viewDidLoad() {
        super.viewDidLoad()
        
            tableView.delegate = self
            tableView.dataSource = self
            
    
    let nibName = UINib(nibName: "SecondSegmentTableViewCell", bundle: nil)
    
    self.tableView.register(nibName, forCellReuseIdentifier: "SecondSegmentTableViewCell")
    }
}

extension SecondSegmentViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            performSegue(withIdentifier: "toCommentVC", sender: nil)
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SecondSegmentTableViewCell", for: indexPath)
        as! SecondSegmentTableViewCell
        
        cell.icon.image = UIImage(systemName: "star.fill")
        cell.textLbl.text = textList[indexPath.row]
        return cell
    }
    
    
}
