//
//  SecondSegmentTableViewCell.swift
//  Learn Connect
//
//  Created by Omer on 6.12.2024.
//

import UIKit

class SecondSegmentTableViewCell: UITableViewCell {

    
    @IBOutlet weak var icon: UIImageView!
    
    @IBOutlet weak var textLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
      
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
 
    }
    
}
