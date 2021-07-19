
import UIKit

class CastCollectionViewCell: UICollectionViewCell, ComponentShimmers {
    
    // MARK:- outlets for the cell
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var lineView: LineView!
    @IBOutlet weak var actorImageView: Profile!
    @IBOutlet weak var actorNameLabel: UILabel!
    @IBOutlet weak var actorCharacterLabel: UILabel!
    
    // MARK:- variables for the cell
    class func identifier() -> String {
        return "\(CastCollectionViewCell.self)"
    }
    
    let cellHeight: CGFloat = 210
    let cornerRadius:CGFloat = 8
    let animationDuration: Double = 0.25
    
    var actorListViewModel: DetailListViewModel?
    var shimmer: ShimmerLayer = ShimmerLayer()
    
    // MARK:- lifeCycle methods for the cell
    override func awakeFromNib() {
        super.awakeFromNib()
        self.hideViews()
        
        self.containerView.setCornerRadius(radius: cornerRadius)
        self.containerView.setBorder(with: UIColor.label.withAlphaComponent(0.15), 2)
    }
    
    // MARK:- delegate functions for collectionView
    func hideViews() {
        ViewAnimationProvider.makeEaseOutAnimation(duration: animationDuration, delay: 0) {
            self.containerView.setOpacity(to: 0)
        }
    }
    
    func showViews() {
        ViewAnimationProvider.makeEaseOutAnimation(duration: animationDuration, delay: 0) {
            self.containerView.setOpacity(to: 1)
        }
    }
    
    func setShimmer() {
        DispatchQueue.main.async { [unowned self] in
            self.lineView.background = Generic.shared.getRandomColor().withAlphaComponent(0.25)
            shimmer.removeLayerIfExists(self)
            shimmer = ShimmerLayer(for: self.containerView, cornerRadius: cornerRadius)
            self.layer.addSublayer(shimmer)
        }
    }
    
    func removeShimmer() {
        shimmer.removeFromSuperlayer()
    }
    
    // MARK:- functions for the cell
    func setupCell(viewModel: MovieCastViewModel?) {
        setShimmer()
        
        guard let viewModel = viewModel else { return }
        self.actorNameLabel.text = viewModel.movieCast.name
        self.actorCharacterLabel.text = viewModel.movieCast.character
        self.actorImageView.cornerRadius = cornerRadius
        
        DispatchQueue.global().async {
            viewModel.posterImage.bind {
                guard let actorImage = $0 else { return }
                DispatchQueue.main.async { [unowned self] in
                    actorImageView.imageView.image = actorImage
                    self.removeShimmer()
                    self.showViews()
                }
            }
        }
    }
}
