
import UIKit

class SimilarCollectionViewCell: UICollectionViewCell, ComponentShimmers {
    
    // MARK:- outlets for the cell
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var posterImageView: UIImageView!
    
    // MARK:- variables for the cell
    class func identifier() -> String {
        return "\(SimilarCollectionViewCell.self)"
    }
    
    let cellHeight: CGFloat = 180
    let cornerRadius:CGFloat = 12
    let animationDuration: Double = 0.25

    var actorListViewModel: DetailListViewModel?
    var shimmer: ShimmerLayer = ShimmerLayer()
   // let buttonAnimationFactory: ButtonAnimationFactory = ButtonAnimationFactory()
  
    
    // MARK:- lifeCycle methods for the cell
    override func awakeFromNib() {
        super.awakeFromNib()
        self.hideViews()
        
        
        self.containerView.setCornerRadius(radius: cornerRadius)
        self.containerView.setBorder(with: UIColor.label.withAlphaComponent(0.15), 2)
       // self.containerView.setShadow(shadowColor: UIColor.gray, shadowOpacity: 1, shadowRadius: 8, offset: CGSize(width: 0, height: 1))

        self.posterImageView.setCornerRadius(radius: cornerRadius)
        self.posterImageView.setBorder(with: UIColor.label.withAlphaComponent(0.15), 2)
    }

   
    
    // MARK:- delegate functions for collectionView
    func hideViews() {
        ViewAnimationFactory.makeEaseOutAnimation(duration: animationDuration, delay: 0) {
            self.containerView.setOpacity(to: 0)
        }
    }
    
    func showViews() {
        ViewAnimationFactory.makeEaseOutAnimation(duration: animationDuration, delay: 0) {
            self.containerView.setOpacity(to: 1)
        }
    }
    
    func setShimmer() {
        DispatchQueue.main.async { [unowned self] in
            shimmer.removeLayerIfExists(self)
            shimmer = ShimmerLayer(for: self.containerView, cornerRadius: cornerRadius)
            self.layer.addSublayer(shimmer)
        }
    }
    
    func removeShimmer() {
        shimmer.removeFromSuperlayer()
    }
    
    // MARK:- functions for the cell
    func setupCell(viewModel: SimilarViewModel?) {
        setShimmer()
        guard let viewModel = viewModel else { return }
        self.posterImageView.setCornerRadius(radius: cornerRadius)
        
        DispatchQueue.global().async {
            viewModel.posterImage.bind {
                guard let actorImage = $0 else { return }
                DispatchQueue.main.async { [unowned self] in
                    self.posterImageView.image = actorImage
                    self.removeShimmer()
                    self.showViews()
                }
            }
        }
    }
}
