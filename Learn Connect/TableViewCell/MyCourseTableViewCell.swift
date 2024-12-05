//
//  MyCourseTableViewCell.swift
//  Learn Connect
//
//  Created by Omer on 5.12.2024.
//

import UIKit

class MyCourseTableViewCell: UITableViewCell {

    @IBOutlet weak var courseLabel: UILabel!
    
    @IBOutlet weak var starRate: UILabel!
    
    static let identifier = "MyCourseTableViewCell"
    static func nib() -> UINib {
        return UINib(nibName: "MyCourseTableViewCell", bundle: nil)
        return UINib(nibName: "MyCourseTableViewCell", bundle: nil)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
