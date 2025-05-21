//
//  MyTabBarItem.swift
//  UIKitTemplate
//
//  Created by 김건우 on 5/10/25.
//

import UIKit

final class MyTabBarItem: UIButton {
    
    private let title: String?
    private let image: UIImage?
    private let selectedImage: UIImage?
    private var tint: UIColor?
    private let index: Int
    
    init(
        title: String?,
        image: UIImage? = nil,
        selectedImage: UIImage? = nil,
        tint: UIColor?,
        tag index: Int
    ) {
        self.title = title
        self.image = image
        self.selectedImage = selectedImage
        self.tint = tint
        self.index = index
        super.init(frame: .zero)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    
    func setTintColor(_ tint: UIColor) {
        self.tint = tint
    }
    
    func applySelectionState(_ selectedIndex: Int) {
        if index == selectedIndex {
            self.configuration?.attributedTitle = attributedTitle(tint ?? .black)
            self.configuration?.preferredSymbolConfigurationForImage = symbolConfiguration(tint ?? .black)

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
}
