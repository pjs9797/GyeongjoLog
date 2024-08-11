import UIKit
import RxSwift

class TabBarController: UITabBarController {
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        
        setupTabBar()
    }
    
    private func setupTabBar() {
        tabBar.backgroundColor = ColorManager.white
        tabBar.tintColor = ColorManager.blue
        tabBar.unselectedItemTintColor = ColorManager.text01
        let textAttributes = AttributedFontManager.SubTitle01
        self.tabBarController?.tabBarItem.setTitleTextAttributes(textAttributes, for: .normal)
    }
}

extension TabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if let viewControllers = viewControllers {
            for (index, vc) in viewControllers.enumerated() {
                if let tabItem = vc.tabBarItem {
                    if index == 0 {
                        tabItem.image = vc == viewController ? ImageManager.icon_event_select?.withRenderingMode(.alwaysOriginal) : ImageManager.icon_event_deselect?.withRenderingMode(.alwaysOriginal)
                    }
                    else if index == 1 {
                        tabItem.image = vc == viewController ? ImageManager.icon_statistics_deselect?.withRenderingMode(.alwaysOriginal) : ImageManager.icon_statistics_deselect?.withRenderingMode(.alwaysOriginal)
                    }
                    else if index == 2 {
                        tabItem.image = vc == viewController ? ImageManager.icon_words_deselect?.withRenderingMode(.alwaysOriginal) : ImageManager.icon_words_deselect?.withRenderingMode(.alwaysOriginal)
                    }
                    else if index == 3 {
                        tabItem.image = vc == viewController ? ImageManager.icon_setting_deselect?.withRenderingMode(.alwaysOriginal) : ImageManager.icon_setting_deselect?.withRenderingMode(.alwaysOriginal)
                    }
                }
            }
        }
    }
}
