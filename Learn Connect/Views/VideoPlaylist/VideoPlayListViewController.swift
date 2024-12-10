//
//  FirstSegmentedViewController.swift
//  Learn Connect
//
//  Created by Omer on 6.12.2024.
//

import UIKit

 
class VideoPlayListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var videoPlayListViewModel = VideoPlayListViewModel()
    weak var delegate: VideoPlayListDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
            tableView.delegate = self
            tableView.dataSource = self
        print(videoPlayListViewModel.myCourse)
    
    let nibName = UINib(nibName: "CourseVideosTableViewCell", bundle: nil)
    
    self.tableView.register(nibName, forCellReuseIdentifier: "CourseVideosTableViewCell")
    }
}

extension VideoPlayListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CourseVideosTableViewCell", for: indexPath)
        as! CourseVideosTableViewCell
            let myCourse = videoPlayListViewModel.myCourse
 
        
        let num = indexPath.row + 1
        
        let title = "\(myCourse!.title ?? "")  - \(num) -"
        cell.name.text = title
        cell.delegate = self
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelectVideo(at: indexPath.row)
    }
    
    
}

extension VideoPlayListViewController: CourseVideosTableViewCellDelegate {
     
    func didTapDownloadButton(in cell: CourseVideosTableViewCell) {
          if let indexPath = tableView.indexPath(for: cell) {
              if let parentVC = self.parent as? VideoLessonViewController
              {
                  parentVC.startDownloadingVideoAndImage()
              }
              
     
          }
      }
    
   
}


