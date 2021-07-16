
import UIKit

// Another way of creating @IBDesignables is without using the custom xib file, create properties and modify it directly, whereever you use this class in the storyboards.
@IBDesignable class LineView: UIView {
    
    // MARK:- variables for the view
    @IBInspectable var cornerRadius: CGFloat = 4 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    var background: UIColor = UIColor.tertiaryLabel {
        didSet {
            self.backgroundColor = background
        }
    }
    
    // MARK:- Initializers for the view
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    override func prepareForInterfaceBuilder() {
         setupView()
     }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    // MARK:- functions for the viewController
    func setupView() {
        self.layer.cornerRadius = cornerRadius
        self.backgroundColor = background
    }
}

