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
        
        JSONDataManager.shared.loadJSONData(categoryName: "computer")
        collectionView.dataSource = self
        collectionView.delegate = self
        let nibName = UINib(nibName: "CourseCollectionViewCell", bundle: nil)
        print( homeViewModel.user)
        self.collectionView.register(nibName, forCellWithReuseIdentifier: "CourseCollectionViewCell")
    }
     

}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:
            "CourseCollectionViewCell", for: indexPath) as! CourseCollectionViewCell

        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
     
        performSegue(withIdentifier: "toCourseDetailVC", sender: nil)
        
    }
}

