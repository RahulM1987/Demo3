
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let MainVC = ViewController() as UIViewController
        self.window?.rootViewController = UINavigationController.init(rootViewController: MainVC)
        return true
    }
    
}

