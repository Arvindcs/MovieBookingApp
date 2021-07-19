

import UIKit

struct Generic {
    let colors = [UIColor.systemRed, UIColor.systemTeal, UIColor.systemIndigo, UIColor.systemOrange, UIColor.systemGreen, UIColor.systemYellow]
    
    static var shared: Generic {
        return Generic()
    }
    
    func getRandomColor() -> UIColor {
        return colors.randomElement()!
    }
}

protocol ComponentShimmers {
    var animationDuration: Double { get }

    func hideViews()
    func showViews()    
    func setShimmer()
    func removeShimmer()
}

class GenericDataSource<T> : NSObject {
    var data: Binding<[T]> = Binding([])
}
