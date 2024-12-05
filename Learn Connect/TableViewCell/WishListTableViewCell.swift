//
//  WishListTableViewCell.swift
//  Learn Connect
//
//  Created by Omer on 5.12.2024.
//

import UIKit

class WishListTableViewCell: UITableViewCell {

    
    @IBOutlet weak var courseLabel: UILabel!
    static let identifier = "WishListTableViewCell"
    static func nib() -> UINib {
        return UINib(nibName: "WishListTableViewCell", bundle: nil)
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
