import Foundation
import UIKit

public protocol WindowScene {
    
    func resume(_ activity: NSUserActivity)
    
    @available(iOS 13.0, *)
    func open(URLContexts: Set<UIOpenURLContext>)
    
}
