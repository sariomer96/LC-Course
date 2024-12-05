//
//  CourseCollectionViewCell.swift
//  Learn Connect
//
//  Created by Omer on 5.12.2024.
//

import UIKit

class CourseCollectionViewCell: UICollectionViewCell {

    static let identifier = "CourseCollectionViewCell"
    static func nib() -> UINib {
        return UINib(nibName: "CourseCollectionViewCell", bundle: nil)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
  
        // Initialization code
    }
}
