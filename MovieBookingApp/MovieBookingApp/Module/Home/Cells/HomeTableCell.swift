
import UIKit

class HomeTableCell: UITableViewCell {
    
    // MARK:- outlets for the cell
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var moviePosterImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieReleaseLabel: UILabel!
    @IBOutlet weak var movieGenreLabel: UILabel!
    @IBOutlet weak var btnBook: UIButton!
    
    // MARK:- Identifier
    class func identifier() -> String {
        return "\(HomeTableCell.self)"
    }

    let cellHeight: CGFloat = 180
    let cornerRadius: CGFloat = 12
    let animationDuration: Double = 0.25
    var shimmer: ShimmerLayer = ShimmerLayer()
    
    // MARK:- lifeCycle methods for the cell
    override func awakeFromNib() {
        super.awakeFromNib()
        self.hideViews()
        
        self.containerView.setCornerRadius(radius: cornerRadius)
        self.containerView.setBorder(with: UIColor.label.withAlphaComponent(0.15), 2)
       // self.containerView.setShadow(shadowColor: UIColor.gray, shadowOpacity: 1, shadowRadius: 8, offset: CGSize(width: 0, height: 1))
        
        self.btnBook.setCornerRadius(radius: cornerRadius)
        self.btnBook.setBorder(with: UIColor.label.withAlphaComponent(0.15), 2)
        
        self.moviePosterImageView.setCornerRadius(radius: cornerRadius)
        self.moviePosterImageView.setBorder(with: UIColor.label.withAlphaComponent(0.15), 2)
    }
    
    // MARK:- delegate functions for collectionView
    private func hideViews() {
         ViewAnimationFactory.makeEaseOutAnimation(duration: animationDuration, delay: 0) {
            self.containerView.setOpacity(to: 0)
         }
     }
     
    private func showViews() {
         ViewAnimationFactory.makeEaseOutAnimation(duration: animationDuration, delay: 0) {
            self.containerView.setOpacity(to: 1)
        }
    }
    
    private func setShimmer() {
        DispatchQueue.main.async { [unowned self] in
            shimmer.removeLayerIfExists(self)
            shimmer = ShimmerLayer(for: self.containerView, cornerRadius: 12)
            self.layer.addSublayer(shimmer)
        }
    }
    
    private func removeShimmer() {
        shimmer.removeFromSuperlayer()
    }
    
    // MARK:- functions for the cell
    public func setupCell(viewModel: MovieViewModel) {
        setShimmer()
        self.movieTitleLabel.text = viewModel.title
        self.movieGenreLabel.text = viewModel.originalTitle
        self.movieReleaseLabel.text = viewModel.releaseDate
        
        DispatchQueue.global().async {
            viewModel.moviePosterImage.bind {
                guard let posterImage = $0 else { return }
                DispatchQueue.main.async { [unowned self] in
                    moviePosterImageView.image = posterImage
                    removeShimmer()
                    showViews()
                }
            }
        }
    }
    
}
