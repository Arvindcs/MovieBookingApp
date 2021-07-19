
import UIKit

enum ViewAnimationProvider {
    static func makeEaseOutAnimation(duration: TimeInterval, delay: TimeInterval, action: @escaping() -> Void) {
        UIView.animate(withDuration: duration, delay: delay, options: .curveEaseOut, animations: {
            action()
        })
    }
}
