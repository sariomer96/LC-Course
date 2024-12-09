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
        print("Current HomeViewController instance: \(self)")

        super.viewDidLoad()
        
        homeViewModel.getCourseContentFromJSon()
        collectionView.dataSource = self
        collectionView.delegate = self
        let nibName = UINib(nibName: "CourseCollectionViewCell", bundle: nil)
 
        self.collectionView.register(nibName, forCellWithReuseIdentifier: "CourseCollectionViewCell")
    }
     
    func reloadData() {
        
        UIView.transition(with: collectionView, duration: 0.4, options: .transitionCrossDissolve, animations: {
            self.collectionView.reloadData()
        }, completion: nil)
    }
    @IBAction func clickedAllBtn(_ sender: Any) {
  
//        collectionView.reloadData()
        
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
            "CourseCollectionViewCell", for: indexPath) as! CourseCollectionViewCell
           
        cell.courseTitle.text = homeViewModel.currentContent?.hits?[indexPath.row].title
        cell.configure(with: homeViewModel.currentContent?.hits?[indexPath.row].videos?.medium?.thumbnail)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
     
        let course =  homeViewModel.currentContent?.hits?[indexPath.row]
        performSegue(withIdentifier: "toCourseDetailVC", sender: course)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCourseDetailVC" {
              if let destinationVC = segue.destination as? CourseDetailViewController,
                 let course = sender as? Hit {
                     
                 let imageUrl =   course.videos?.medium?.thumbnail
                  destinationVC.configure(with: imageUrl)
              }
          }
    }
}

