
import Foundation
import UIKit

extension UIViewController {
    
    func showAlert(withTitle: String, andMessage: String, onController: UIViewController, actions: [UIAlertAction]) {
        let alertController = UIAlertController(title: withTitle, message: andMessage, preferredStyle: .alert)
        for action in actions {
            alertController.addAction(action)
        }
        onController.present(alertController, animated: true, completion: nil)
    }
    
    //MARK:- storyboard
    class var storyboardID: String {
        return "\(self)"
    }
    
    static func instantiate(from: AppStoryboard) -> Self {
        return from.viewController(viewControllerClass: self)
    }
}
