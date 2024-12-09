//
//  CourseCollectionViewCell.swift
//  Learn Connect
//
//  Created by Omer on 5.12.2024.
//

import UIKit

class CourseCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var rateLabel: UILabel!
    
    @IBOutlet weak var courseTitle: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    static let identifier = "CourseCollectionViewCell"
    static func nib() -> UINib {
        return UINib(nibName: "CourseCollectionViewCell", bundle: nil)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
  
        // Initialization code
    }
    
    
    func configure(with urlString: String?) {
        guard let url = URL(string: urlString ?? "") else { return }
      
       URLSession.shared.dataTask(with: url) { data, response, error in
           if let data = data, let image = UIImage(data: data) {
               DispatchQueue.main.async {
                   self.thumbnailImageView.image = image
               }
           }
       }.resume()
   }
}
