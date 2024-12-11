//
//  HomeViewController.swift
//  Learn Connect
//
//  Created by Omer on 5.12.2024.
//

import UIKit

class HomeViewController: UIViewController {

   
    
    @IBOutlet var collectionView: UICollectionView!
    
   
    let homeViewModel = HomeViewModel()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.navigationItem.hidesBackButton = true
    }
    override func viewDidLoad() {
 

        super.viewDidLoad()
        homeViewModel.scheduleLocalNotification()
        homeViewModel.getCourseContentFromJSon()
        collectionView.dataSource = self
        collectionView.delegate = self
        let nibName = UINib(nibName: homeViewModel.courseCollectionViewCellId, bundle: nil)
 
        self.collectionView.register(nibName, forCellWithReuseIdentifier: homeViewModel.courseCollectionViewCellId)
    }
     
    func reloadData() {
        
        UIView.transition(with: collectionView, duration: 0.4, options: .transitionCrossDissolve, animations: {
            self.collectionView.reloadData()
        }, completion: nil)
    }
    @IBAction func clickedAllBtn(_ sender: Any) {
   
        refreshCheck(content: homeViewModel.allVideoContent)

    }
    
    func  refreshCheck(content:CourseContent?) {
        if homeViewModel.currentContent != content {
            homeViewModel.currentContent = content
            reloadData()
        }
        
        
    }
    @IBAction func clickedSoftwareBtn(_ sender: Any) {
        
        refreshCheck(content: homeViewModel.computer)
      
    }
    
    @IBAction func clickedScienceBtn(_ sender: Any) {
        refreshCheck(content: homeViewModel.science)
    }
    @IBAction func clickedEducationBtn(_ sender: Any) {
        refreshCheck(content: homeViewModel.education)
    }
    
    @IBAction func clickedMusicBtn(_ sender: Any) {
        refreshCheck(content: homeViewModel.music)
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return homeViewModel.currentContent?.hits?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:
                                                        homeViewModel.courseCollectionViewCellId, for: indexPath) as! CourseCollectionViewCell
           
        cell.courseTitle.text = homeViewModel.currentContent?.hits?[indexPath.row].title
        cell.configure(with: homeViewModel.currentContent?.hits?[indexPath.row].videos?.medium?.thumbnail)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
     
        let course =  homeViewModel.currentContent?.hits?[indexPath.row]
        performSegue(withIdentifier: homeViewModel.courseDetailId, sender: course)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == homeViewModel.courseDetailId {
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
extension UIViewController {
    func showToast(message: String, duration: Double = 2.0) {
        let toastContainer = UIView(frame: CGRect())
        toastContainer.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.9)
        toastContainer.layer.cornerRadius = 25
        toastContainer.clipsToBounds = true
        toastContainer.layer.shadowColor = UIColor.black.cgColor
        toastContainer.layer.shadowOpacity = 0.4
        toastContainer.layer.shadowOffset = CGSize(width: 0, height: 4)
        toastContainer.layer.shadowRadius = 8

        let toastLabel = UILabel(frame: CGRect())
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center
        toastLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        toastLabel.text = message
        toastLabel.numberOfLines = 0

        toastContainer.addSubview(toastLabel)
        self.view.addSubview(toastContainer)
 
        toastLabel.translatesAutoresizingMaskIntoConstraints = false
        toastContainer.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            toastLabel.leadingAnchor.constraint(equalTo: toastContainer.leadingAnchor, constant: 20),
            toastLabel.trailingAnchor.constraint(equalTo: toastContainer.trailingAnchor, constant: -20),
            toastLabel.topAnchor.constraint(equalTo: toastContainer.topAnchor, constant: 15),
            toastLabel.bottomAnchor.constraint(equalTo: toastContainer.bottomAnchor, constant: -15),

            toastContainer.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            toastContainer.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -120),
            toastContainer.widthAnchor.constraint(lessThanOrEqualToConstant: 350)
        ])
 
        toastContainer.transform = CGAffineTransform(translationX: 0, y: self.view.frame.size.height)
 
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.8, options: .curveEaseOut, animations: {
            toastContainer.transform = .identity
        }) { _ in
         
            UIView.animate(withDuration: 0.4, delay: duration, options: .curveEaseIn, animations: {
                toastContainer.alpha = 0.0 
            }) { _ in
                toastContainer.removeFromSuperview()
            }
        }
    }
}
