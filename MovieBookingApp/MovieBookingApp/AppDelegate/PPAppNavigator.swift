
import UIKit

class PPAppNavigator: NSObject {
    
    static
    func switchToHomeVC() {
        let vc = HomeViewController.instantiate(from: .main)
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let navVC = PPAppNavigator.getNavVC(rootViewController: vc)
            appDelegate.window?.rootViewController = navVC
        }
    }
    
    static
    func getNavVC(rootViewController: UIViewController) -> UINavigationController {
        let navVC = UINavigationController(rootViewController: rootViewController)
        navVC.navigationBar.isHidden = true
        return navVC
    }
}
