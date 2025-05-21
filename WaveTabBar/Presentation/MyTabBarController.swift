//
//  MyTabBarController.swift
//  UIKitTemplate
//
//  Created by 김건우 on 4/4/25.
//

import UIKit

final class MyTabBarController: UITabBarController {
    
    /// 사용자 정의 탭바를 구성하는 `MyTabBar` 인스턴스입니다.
    private let myTabBar = MyTabBar()

    /// 탭바 아이템에 적용할 틴트 색상입니다.
    /// 변경 시 모든 아이템의 색상을 업데이트합니다.
    var tintColor: UIColor = .label {
        didSet { configureTabBarTint() }
    }

    /// 현재 선택된 탭의 인덱스입니다.
    /// 값이 변경되면 커스텀 탭바에도 선택 상태를 반영합니다.
    override var selectedIndex: Int {
        didSet { myTabBar.updateSelctedTab(selectedIndex) }
    }

    /// 탭바에 표시할 뷰 컨트롤러들을 설정합니다.
    /// - Parameters:
    ///   - viewControllers: 탭으로 구성할 뷰 컨트롤러 배열
    ///   - animated: 애니메이션 적용 여부
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

    /// 커스텀 탭바의 표시 여부를 설정합니다.
    /// - Parameters:
    ///   - hidden: `true`일 경우 탭바를 숨기고, `false`일 경우 다시 표시합니다.
    ///   - animated: 애니메이션을 적용할지 여부 (`true`일 경우 0.25초 동안 애니메이션 적용)
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

    private func setupUI() {
        self.tabBar.isHidden = true
        view.addSubview(myTabBar)

        myTabBar.delegate = self
        myTabBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            myTabBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 15),
            myTabBar.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            myTabBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -15),
            myTabBar.heightAnchor.constraint(equalToConstant: 65)
        ])
    }
}


extension MyTabBarController {
    
    private func configureTabBarItems() {
        if let items = viewControllers?.compactMap(\.tabBarItem) {
            let myTabBarItems = items.enumerated().map {
                MyTabBarItem(
                    title: $1.title ?? "",
                    image: $1.image,
                    selectedImage: $1.selectedImage,
                    tintColor: tintColor,
                    tag: $0
                )
            }
            myTabBar.updateTabBarItems(myTabBarItems)
        }
    }

    private func configureTabBarTint() {
        myTabBar.tintColor = tintColor
        myTabBar.reloadTabBarItem(selectedIndex)
    }

    private func configureIntialState() {
        myTabBar.animateIntialState()
    }
}

extension MyTabBarController: MyTabBarDelegate {
    
    func tabBar(
        _ tabBar: MyTabBar,
        didSelect items: MyTabBarItem,
        at index: Int
    ) {
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
    tabBarController.tintColor = .systemMint
//    tabBarController.setTabBarHidden(true)
    return tabBarController
}
