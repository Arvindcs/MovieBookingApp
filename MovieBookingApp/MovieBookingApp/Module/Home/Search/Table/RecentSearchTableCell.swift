
import UIKit

class RecentSearchTableCell: UITableViewCell {
    
    //MARK:- IBOutlet
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    
    
    // MARK:- Identifier
    class func identifier() -> String {
        return "\(RecentSearchTableCell.self)"
    }
    
    let cellHeight: CGFloat = 60
    let headerHeight: CGFloat = 40
    let cornerRadius: CGFloat = 12
    
    // MARK:- lifeCycle methods for the cell
    override func awakeFromNib() {
        super.awakeFromNib()
        self.containerView.setCornerRadius(radius: cornerRadius)
        self.containerView.setBorder(with: UIColor.label.withAlphaComponent(0.15), 2)
    }
    
    // MARK:- functions for the cell
    public func setupCell(movie: MovieList) {
        self.lblTitle.text = movie.title
    }
}
