//
//  MyTabBarItem.swift
//  UIKitTemplate
//
//  Created by 김건우 on 5/10/25.
//

import UIKit

final class MyTabBarItem: UIButton {

    /// 버튼의 제목 텍스트입니다.
    private let title: String?
    /// 버튼에 표시할 기본 이미지입니다.
    private let image: UIImage?
    /// 버튼이 선택되었을 때 표시할 이미지입니다.
    private let selectedImage: UIImage?
    /// 버튼의 인덱스를 나타내는 정수 값입니다.
    private let index: Int

    /// 버튼이 하이라이트 상태로 변경될 때 호출되어 상태를 업데이트합니다.
    override var isHighlighted: Bool {
        didSet { updateSelectionState() }
    }

    /// 커스텀 탭바 버튼을 초기화합니다.
    /// - Parameters:
    ///   - title: 버튼에 표시할 텍스트
    ///   - image: 기본 상태에서 표시할 이미지 (선택 사항)
    ///   - selectedImage: 선택된 상태에서 표시할 이미지 (선택 사항)
    ///   - tintColor: 이미지 및 텍스트에 적용할 틴트 색상
    ///   - index: 버튼의 위치를 나타내는 인덱스 값 (tag 용도로 사용)
    init(
        title: String?,
        image: UIImage? = nil,
        selectedImage: UIImage? = nil,
        tintColor: UIColor?,
        tag index: Int
    ) {
        self.title = title
        self.image = image
        self.selectedImage = selectedImage
        self.index = index
        super.init(frame: .zero)
        
        self.tintColor = tintColor

        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func tintColorDidChange() {
        self.tintColor = tintColor
    }

    private func setupUI() {
        self.tag = index
        self.setImage(image, for: .normal)
        
        var config = UIButton.Configuration.plain()
        if let _ = title {
            config.titleAlignment = .center
            config.attributedTitle = attributedTitle(.secondaryLabel)
        }
        
        config.imagePadding = 6
        config.imagePlacement = .top
        config.preferredSymbolConfigurationForImage = symbolConfiguration(.secondaryLabel)
        
        config.background.backgroundColor = .clear
        self.configuration = config
    }
}

extension MyTabBarItem {
    
    func applySelectionState(_ selectedIndex: Int) {
        if index == selectedIndex {
            self.configuration?.attributedTitle = attributedTitle(tintColor ?? .black)
            self.configuration?.preferredSymbolConfigurationForImage = symbolConfiguration(tintColor ?? .black)

            if let selectedImage = selectedImage {
                self.setImage(selectedImage, for: .normal)
            }
            
        } else {
            self.configuration?.attributedTitle = attributedTitle(.secondaryLabel)
            self.configuration?.preferredSymbolConfigurationForImage = symbolConfiguration(.secondaryLabel)
            self.setImage(image, for: .normal)
        }
    }
    
    private func attributedTitle(_ foregroundColor: UIColor) -> AttributedString {
        return AttributedString(
            title ?? "",
            attributes: AttributeContainer(
                [.font: UIFont.preferredFont(forTextStyle: .caption1),
                 .foregroundColor: foregroundColor]
            )
        )
    }
    
    private func symbolConfiguration(_ foregroundColor: UIColor) -> UIImage.SymbolConfiguration {
        return UIImage.SymbolConfiguration(
            font: .preferredFont(forTextStyle: .callout)
        ).applying(
            UIImage.SymbolConfiguration(paletteColors: [foregroundColor])
        )
    }

    private func updateSelectionState() {
        if isHighlighted {
            self.layer.opacity = 0.5
        } else {
            self.layer.opacity = 1.0
        }
    }
}
