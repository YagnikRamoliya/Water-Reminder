import UIKit

class CustomTabBar: UITabBarController, UITabBarControllerDelegate {
    
    private let homeButton = UIButton()
    var initialIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        
        setupViewControllers()
        styleTabBar()
        setupMiddleButton()
      
        self.selectedIndex = initialIndex   
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    // MARK: - Setup Tabs
    private func setupViewControllers() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let historyVC = storyboard.instantiateViewController(withIdentifier: "HistoryViewController")
        historyVC.tabBarItem = UITabBarItem(title: "History", image: UIImage(named: "history"), selectedImage: UIImage(named: "history"))
        
        let homeVC = storyboard.instantiateViewController(withIdentifier: "HomeViewController")
        homeVC.tabBarItem = UITabBarItem(title: nil, image: nil, selectedImage: nil) // Hidden from tabbar
        
        let settingsVC = storyboard.instantiateViewController(withIdentifier: "SettingsViewController")
        settingsVC.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(named: "settings"), selectedImage: UIImage(named: "settings"))
        
        self.viewControllers = [historyVC, homeVC, settingsVC]
    }
    
    // MARK: - Style TabBar
    private func styleTabBar() {
        let inset: CGFloat = 16
        let height: CGFloat = 60
        
        // TabBar ka frame adjust
        let safeAreaBottom = view.safeAreaInsets.bottom
        let newFrame = CGRect(
            x: inset,
            y: view.frame.height - height - safeAreaBottom - 16,
            width: view.frame.width - inset * 2,
            height: height
        )
        
        tabBar.frame = newFrame
        tabBar.layer.cornerRadius = height / 2
        tabBar.layer.masksToBounds = false
        
        // Shadow
        tabBar.layer.shadowColor = UIColor.black.cgColor
        tabBar.layer.shadowOpacity = 0.15
        tabBar.layer.shadowOffset = CGSize(width: 0, height: 4)
        tabBar.layer.shadowRadius = 8
        
        // Background color
        tabBar.barTintColor = .white
        tabBar.backgroundColor = .white
        tabBar.itemWidth = (tabBar.frame.width) / 3
        tabBar.itemPositioning = .centered
    }
    
    // MARK: - Middle Home Button
    private func setupMiddleButton() {
        homeButton.frame = CGRect(x: 0, y: 0, width: 64, height: 64)
        homeButton.layer.cornerRadius = 32
        homeButton.backgroundColor = .white
        homeButton.setImage(UIImage(named:"home"), for: .normal)
        homeButton.imageView?.contentMode = .scaleAspectFit
        
        // Shadow
        homeButton.layer.shadowColor = UIColor.black.cgColor
        homeButton.layer.shadowOpacity = 0.1
        homeButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        homeButton.layer.shadowRadius = 5
        
        homeButton.addTarget(self, action: #selector(homeButtonTapped), for: .touchUpInside)
        view.addSubview(homeButton)
    }
    
    @objc private func homeButtonTapped() {
        self.selectedIndex = 1
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Re-apply floating tab bar layout after rotation/safe area change
        styleTabBar()
        
        // Middle button position
        homeButton.center = CGPoint(
            x: view.bounds.width / 2,
            y: tabBar.frame.origin.y
        )
    }
}
