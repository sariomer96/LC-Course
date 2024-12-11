 

import UIKit

class CourseDetailViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var courseName: UILabel!
    @IBOutlet weak var tableView: UITableView!
    private var courseTitle: String?
    let courseDetailViewModel = CourseDetailViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        tableView.delegate = self
        tableView.dataSource = self
        
        DatabaseManager.shared.errorCallback = { error in
            self.showAlert(message: error!)
        }
        
        DatabaseManager.shared.successCallback = { success in
            self.showAlert(message: success!,isSuccess:  true)
        }
        
        let nibName = UINib(nibName: "CommentTableViewCell", bundle: nil)
        
        self.tableView.register(nibName, forCellReuseIdentifier: "CommentTableViewCell")
        if let courseTitle = courseTitle {
                    courseName.text = courseTitle
                }
    }
    func setCourseName(title: String) {
        self.courseTitle = title
        }
    
    @IBAction func ClickedWishlist(_ sender: Any) {
 
        courseDetailViewModel.subscribeAndWishListCourse(isLiked: 1, isSub: nil)
    }
    
    @IBAction func ClickedSubscribeToCourse(_ sender: Any) {
 
        courseDetailViewModel.subscribeAndWishListCourse(isLiked: nil, isSub: 1)
    }
    func showAlert(message: String, isSuccess: Bool = false) {
        let alert = UIAlertController(title: isSuccess ? " Başarılı" : "Hata",
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    func configure(with urlString: String?) {
        guard let url = URL(string: urlString ?? "") else { return }
      
       URLSession.shared.dataTask(with: url) { data, response, error in
           if let data = data, let image = UIImage(data: data) {
               DispatchQueue.main.async {
                   self.imageView?.image = image
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

