//
//  ReviewCollectionViewCell.swift
//  FightClub
//
//  Created by Aloha on 28/06/21.
//

import UIKit


class ReviewCollectionViewCell: UICollectionViewCell, ComponentShimmers {
    
    // MARK:- outlets for the cell
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var personImageView: Profile!
    
    @IBOutlet weak var personNameLabel: UILabel!
    @IBOutlet weak var ratingView: StarRatingView!
    @IBOutlet weak var ratingTextLabel: UILabel!
    @IBOutlet weak var ratingDescriptionLabel: UITextView!
    
    
    // MARK:- variables for the cell
    class func identifier() -> String {
        return "\(ReviewCollectionViewCell.self)"
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
    func setupCell(viewModel: MovieReviewViewModel?) {
        setShimmer()
        
        guard let viewModel = viewModel else { return }
        self.personNameLabel.text = viewModel.movieReview.author
        let rating = (viewModel.movieReview.authorDetails?.rating ?? 0)/2
      
        self.ratingView.rating = Float(rating)
        self.ratingTextLabel.text = "\(rating)"
        self.ratingDescriptionLabel.attributedText = NSAttributedString(string: viewModel.movieReview.content ?? "")
        self.personImageView.cornerRadius = 20
        
        DispatchQueue.global().async {
            viewModel.posterImage.bind {
                guard let actorImage = $0 else { return }
                DispatchQueue.main.async { [unowned self] in
                    personImageView.imageView.image = actorImage
                    self.removeShimmer()
                    self.showViews()
                }
            }
        }
    }
}
