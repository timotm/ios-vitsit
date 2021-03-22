import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    let jokeVMController = JokeViewModelController()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        jokeVMController.load()
        let rootViewController = RootViewController(vmController: jokeVMController)
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()
        return true
    }
}

