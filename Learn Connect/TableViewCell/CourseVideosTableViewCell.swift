
import UIKit

protocol CourseVideosTableViewCellDelegate: AnyObject {
    func didTapDownloadButton(in cell: CourseVideosTableViewCell)
}


class CourseVideosTableViewCell: UITableViewCell {

    @IBOutlet weak var downloadButton: UIButton!
    @IBOutlet weak var name: UILabel!
 
    weak var delegate: CourseVideosTableViewCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func clickedDownloadBtn(_ sender: Any) {
        delegate?.didTapDownloadButton(in: self)
        downloadButton.isEnabled = false
        
    }
    
    func setDownloadCompleted() {
      downloadButton.isEnabled = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
      
    }
    
}

