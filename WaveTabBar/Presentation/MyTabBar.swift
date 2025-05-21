//
//  MyTabBar.swift
//  UIKitTemplate
//
//  Created by 김건우 on 5/10/25.
//

import UIKit

@MainActor
protocol MyTabBarDelegate: AnyObject {

    /// 사용자가 탭바 아이템을 선택했을 때 호출됩니다.
    /// - Parameters:
    ///   - tabBar: 탭 이벤트가 발생한 `MyTabBar` 인스턴스
    ///   - item: 선택된 `MyTabBarItem`
    ///   - index: 선택된 항목의 인덱스
    func tabBar(
        _ tabBar: MyTabBar,
        didSelect item: MyTabBarItem,
        at index: Int
    )
}

final class MyTabBar: UIView {

    enum Metric {
        /// 스택 뷰의 좌우 패딩 값입니다.
        static let stackHorizontalPadding: CGFloat = 20
    }

    private let container = UIView()
    private let stackView = UIStackView()
    private let circle = Circle()
    private let wavyBottom = Wavy()

    /// 현재 탭바에 포함된 버튼 항목들입니다.
    /// 항목이 변경되면 레이아웃을 즉시 갱신합니다.
    private var tabBarItems: [MyTabBarItem] = [] {
        didSet { self.layoutIfNeeded() }
    }

    /// 현재 선택된 탭의 인덱스를 나타냅니다.
    private var currentIndex: Int = 0

    /// 탭 항목 선택 이벤트를 전달할 델리게이트입니다.
    weak var delegate: (any MyTabBarDelegate)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        retainPositionAtCurrentIndex()
    }

    override func tintColorDidChange() {
        circle.tintColor = tintColor
        tabBarItems.forEach { $0.tintColor = tintColor }
    }

    private func setupUI() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.22
        self.layer.shadowRadius = 10
        self.layer.shadowOffset = CGSize(width: 5, height: 5)

        self.addSubview(container)
        container.backgroundColor = .systemBackground
        container.layer.cornerRadius = 20
        container.layer.masksToBounds = false
        container.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            container.topAnchor.constraint(equalTo: self.topAnchor),
            container.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            container.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])

        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false

        container.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: Metric.stackHorizontalPadding),
            stackView.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            stackView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -Metric.stackHorizontalPadding),
        ])

        self.addSubview(circle)
        circle.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            circle.widthAnchor.constraint(equalToConstant: 10),
            circle.heightAnchor.constraint(equalToConstant: 10),
            circle.topAnchor.constraint(equalTo: self.stackView.bottomAnchor, constant: 10)
        ])
    }

    @objc private func handleTabBarItemTap(_ sender: MyTabBarItem) {
        delegate?.tabBar(self, didSelect: sender, at: sender.tag)

        currentIndex = sender.tag
        let targetOffsetX = targetOffsetX(currentIndex)
        animate(currentIndex, to: targetOffsetX)

        for item in tabBarItems where item !== sender {
            animateTabBarItem(item.tag, to: 0)
        }
    }

    private func applyWavyBottomMask(_ offsetX: CGFloat) {
        //
        let maskLayer = CAShapeLayer()
        maskLayer.path = wavyBottom.createPath(self.bounds, offsetX: offsetX).cgPath
        maskLayer.fillColor = UIColor.black.cgColor
        maskLayer.frame = self.bounds
        //
        container.layer.mask = maskLayer
    }
}

extension MyTabBar {

    private func retainPositionAtCurrentIndex() {
        let targetOffetX = targetOffsetX(currentIndex)
        applyWavyBottomMask(targetOffetX)
        animateCircle(to: targetOffetX, withDuration: 0)
    }

    /// 초기 선택 상태를 0번째 탭으로 설정하고, 해당 위치에 맞춰 애니메이션과 마스크를 적용합니다.
    func animateIntialState() {
        if let _ = tabBarItems.first {
            let targetOffsetX = targetOffsetX(0)
            animate(0, to: targetOffsetX, withDuration: 0.0)
            applyWavyBottomMask(targetOffsetX)
        }
    }

    private func animate(
        _ selectedIndex: Int,
        to targetOffset: CGFloat,
        withDuration duration: TimeInterval = 0.25
    ) {
        animateTabBarItem(selectedIndex, withDuration: duration)
        animateCircle(to: targetOffset, withDuration: duration)
        animateWavyBottom(to: targetOffset, withDuration: duration)
    }

    private func animateTabBarItem(
        _ selectedIndex: Int,
        to offsetY: CGFloat = -10,
        withDuration duration: TimeInterval = 0.25
    ) {
        UIView.animate(withDuration: duration) {
            self.tabBarItems[selectedIndex].transform = CGAffineTransform(translationX: 0, y: offsetY)
        }
    }

    private func animateCircle(
        to targetOffsetX: CGFloat,
        withDuration duration: TimeInterval = 0.25
    ) {
        UIView.animate(withDuration: duration, delay: 0.0, options: .curveEaseInOut) {
            self.circle.center.x = targetOffsetX
        }
    }

    private func animateWavyBottom(
        to targetOffsetX: CGFloat,
        withDuration duration: TimeInterval = 0.25
    ) {
        guard let maskLayer = container.layer.mask as? CAShapeLayer else { return }

        let fromPath = maskLayer.path
        let toPath = wavyBottom.createPath(self.bounds, offsetX: targetOffsetX).cgPath

        //
        let animation = CABasicAnimation(keyPath: "path")
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.fromValue = fromPath
        animation.toValue = toPath
        animation.duration = duration

        maskLayer.add(animation, forKey: "pathAnimation")
        maskLayer.path = toPath
    }
}

extension MyTabBar {

    /// 현재 선택된 탭의 인덱스를 기준으로 각 탭 항목의 선택 상태를 업데이트합니다.
        /// - Parameter selectedIndex: 선택된 탭의 인덱스
    func updateSelctedTab(_ selectedIndex: Int) {
        tabBarItems.forEach { item in
            item.applySelectionState(selectedIndex)
        }
    }
    
    /// 탭바에 표시할 항목들을 업데이트하고, 각각에 터치 이벤트를 등록합니다.
    /// - Parameter items: 새로 설정할 탭바 항목 배열
    func updateTabBarItems(_ items: [MyTabBarItem]) {
        tabBarItems = items
        items.forEach {
            $0.addTarget(
                self,
                action: #selector(handleTabBarItemTap),
                for: .touchUpInside
            )
        }
        stackView.replaceArrangedSubviews(items)
    }

    /// 지정한 인덱스의 탭 항목만 선택 상태로 다시 렌더링합니다.
    /// - Parameter selectedIndex: 선택 상태를 적용할 항목의 인덱스
    func reloadTabBarItem(_ selectedIndex: Int) {
        tabBarItems[selectedIndex].applySelectionState(selectedIndex)
    }
}


extension MyTabBar {

    private func targetOffsetX(_ currentIndex: Int) -> CGFloat {
        tabBarItems[currentIndex].center.x + Metric.stackHorizontalPadding
    }
}
