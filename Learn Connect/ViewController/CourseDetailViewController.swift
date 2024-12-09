 

import UIKit

class CourseDetailViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var courseName: UILabel!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
            
        tableView.delegate = self
        tableView.dataSource = self
        
        
        let nibName = UINib(nibName: "CommentTableViewCell", bundle: nil)
        
        self.tableView.register(nibName, forCellReuseIdentifier: "CommentTableViewCell")
       
    }
    @IBAction func ClickedWishlist(_ sender: Any) {
    }
    
    @IBAction func ClickedSubscribeToCourse(_ sender: Any) {
    }
    
    
    func configure(with urlString: String?) {
        guard let url = URL(string: urlString ?? "") else { return }
      
       URLSession.shared.dataTask(with: url) { data, response, error in
           if let data = data, let image = UIImage(data: data) {
               DispatchQueue.main.async {
                   self.imageView.image = image
               }
           }
       }.resume()
   }
}

extension CourseDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell", for: indexPath) as! CommentTableViewCell
        
        return cell
    }
    
    
}

