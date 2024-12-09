//
//  MyCourseTableViewCell.swift
//  Learn Connect
//
//  Created by Omer on 5.12.2024.
//

import UIKit

class MyCourseTableViewCell: UITableViewCell {

    @IBOutlet weak var courseLabel: UILabel!
    
    @IBOutlet weak var courseImageView: UIImageView!
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
    
    func configure(with urlString: String?) {
        guard let url = URL(string: urlString ?? "") else { return }
      
       URLSession.shared.dataTask(with: url) { data, response, error in
           if let data = data, let image = UIImage(data: data) {
               DispatchQueue.main.async {
                   self.courseImageView.image = image
               }
           }
       }.resume()
   }

    
}
