//
//  MyTabBarController.swift
//  UIKitTemplate
//
//  Created by 김건우 on 4/4/25.
//

import UIKit

final class MyTabBarController: UITabBarController {
    
    ///
    private let myTabBar = MyTabBar()

    ///
    private var myTabBarItems: [MyTabBarItem] = []
    
    /// <#Description#>
    var tintColor: UIColor = .label {
        didSet { configureTabBarTint() }
    }
    
    /// <#Description#>
    override var selectedIndex: Int {
        didSet { myTabBar.updateSelctedTab(selectedIndex) }
    }
    
    /// <#Description#>
    /// - Parameters:
    ///   - viewControllers: <#viewControllers description#>
    ///   - animated: <#animated description#>
    override func setViewControllers(_ viewControllers: [UIViewController]?, animated: Bool) {
        super.setViewControllers(viewControllers, animated: animated)
        configureTabBarItems()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureIntialState()
    }

    /// <#Description#>
    /// - Parameters:
    ///   - hidden: <#hidden description#>
    ///   - animated: <#animated description#>
    override func setTabBarHidden(_ hidden: Bool, animated: Bool = true) {
        if hidden {
            UIView.animate(withDuration: animated ? 0.25 : 0) { [self] in
                let yDistance = view.frame.maxY - myTabBar.frame.origin.y
                self.myTabBar.transform = CGAffineTransform(translationX: 0, y: yDistance)
            }
        } else {
            UIView.animate(withDuration: animated ? 0.25 : 0) { [self] in
                self.myTabBar.transform = .identity
            }
        }
    }

    /// <#Description#>
    private func setupUI() {
        self.tabBar.isHidden = true
        view.addSubview(myTabBar)

        myTabBar.delegate = self
        myTabBar.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            myTabBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            myTabBar.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -30),
            myTabBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            myTabBar.heightAnchor.constraint(equalToConstant: 65)
        ])
    }
}


extension MyTabBarController {
    
    /// <#Description#>
    private func configureTabBarItems() {
        if let items = viewControllers?.compactMap(\.tabBarItem) {
            selectedIndex = 0
            // Stack에 아이템을 모두 추가하여 렌더링한 후,
            // selectedIndex를 지정해야 강조 색상이 올바르게 반영됩니다.
            myTabBarItems = items.enumerated().map {
                MyTabBarItem(
                    title: $1.title ?? "",
                    image: $1.image,
                    selectedImage: $1.selectedImage,
                    tint: myTabBar.tintColor,
                    tag: $0
                )
            }
            myTabBar.updateTabBarItems(myTabBarItems)
        }
    }
    
    /// <#Description#>
    private func configureTabBarTint() {
        myTabBar.updateTintColor(tintColor)
        myTabBar.reloadTabBarItem(selectedIndex)
    }
    
    /// <#Description#>
    private func configureIntialState() {
        myTabBar.animateIntialState()
    }
}

extension MyTabBarController: MyTabBarDelegate {
    
    func tabBar(_ tabBar: MyTabBar, didSelect items: MyTabBarItem, at index: Int) {
        selectedIndex = index
    }
}

#Preview {
    let firstViewController = FirstViewController()
    firstViewController.tabBarItem = UITabBarItem(
        title: nil,
        image: UIImage(systemName: "house"),
        selectedImage: UIImage(systemName: "house.fill")
    )
    let secondViewController = SecondViewController()
    secondViewController.tabBarItem = UITabBarItem(
        title: nil,
        image: UIImage(systemName: "star"),
        selectedImage: UIImage(systemName: "star.fill")
    )
    let thirdViewController = ThirdViewController()
    thirdViewController.tabBarItem = UITabBarItem(
        title: nil,
        image: UIImage(systemName: "magnifyingglass"),
        selectedImage: UIImage(systemName: "magnifyingglass")
    )
    let fourthViewController = ThirdViewController()
    fourthViewController.tabBarItem = UITabBarItem(
        title: nil,
        image: UIImage(systemName: "gear"),
        selectedImage: UIImage(systemName: "gear.fill")
    )
    let tabBarController = MyTabBarController()
    tabBarController.setViewControllers(
        [firstViewController, secondViewController, thirdViewController, fourthViewController],
        animated: false
    )
    tabBarController.tintColor = .systemRed
//    tabBarController.setTabBarHidden(true)
    return tabBarController
}
