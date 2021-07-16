
import Foundation

class BoxBind<T> {

    
    typealias CompletionHandler = ((T) -> Void)
    typealias Listener = (T) -> ()
    private var observers = [String: CompletionHandler]()
    
    // MARK:- variables for the binder
    var value: T {
        didSet {
            listener?(value)
        }
    }

    var listener: Listener?
    
    // MARK:- initializers for the binder
    init(_ value: T) {
        self.value = value
    }
    
    // MARK:- functions for the binder
    func bind(listener: Listener?) {
        self.listener = listener
        listener?(value)
    }
    
    /// Method to add observer on datasource to update its dat
    
    public func addObserver(_ observer: NSObject, completionHandler: @escaping CompletionHandler) {
        observers[observer.description] = completionHandler
    }
    
    /// Add and notify observer method update data and notify the listner
    
    public func addAndNotify(observer: NSObject, completionHandler: @escaping CompletionHandler) {
        self.addObserver(observer, completionHandler: completionHandler)
        self.notify()
    }
    
    
    /// Method to notify datasource listner to update UI or perform required action
    
    private func notify() {
        observers.forEach({ $0.value(value) })
    }
    
    /// MARK : - De-Initializer
    
    deinit {
        observers.removeAll()
    }
}
