//
//  CourseFolderPickerView.swift
//  BariBari
//
//  Created by Goo on 4/3/25.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class CourseFolderPickerButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        showsMenuAsPrimaryAction = true
        changesSelectionAsPrimaryAction = true
        
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = AppColor.lightGray.value
        config.baseForegroundColor = AppColor.black.value
        
        var attributedTitle = AttributedString(C.courseFolderPickerTitle)
        attributedTitle.font = AppFont.text1.value
        config.attributedTitle = attributedTitle
        config.titleLineBreakMode = .byTruncatingTail
        
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 8)
        let image = UIImage(systemName: AppIcon.folder.value, withConfiguration: imageConfig)?
            .withTintColor(AppColor.black.value, renderingMode: .alwaysOriginal)
        config.image = image
        config.imagePlacement = .leading
        config.imagePadding = 4
        
        config.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10)
        config.cornerStyle = .medium
        
        configuration = config
        
        configurationUpdateHandler = { button in
            var updatedConfig = button.configuration
            
            if let title = button.configuration?.title {
                var attributedTitle = AttributedString(title)
                attributedTitle.font = AppFont.text1.value
                config.attributedTitle = attributedTitle
                config.titleLineBreakMode = .byTruncatingTail
                updatedConfig?.attributedTitle = attributedTitle
            }
            
            button.configuration = updatedConfig
        }
    }
    
    func setMenu(_ info: ( //refactor handler 대신 observer로 selectedElement 관리
        items: [CourseFolder],
        createFolderHandler: (() -> Void)?,
        completionHandler: ((CourseFolder) -> Void)?
    )) {
        var menuItems: [UIAction] = info.items.reversed().map { item in
            UIAction(
                title: item.title,
                handler: { _ in info.completionHandler?(item) }
            )
        }
        
        menuItems.append(
            UIAction(
                title: C.courseFolderCreateTitle,
                image: UIImage(systemName: AppIcon.plus.value),
                state: .off,
                handler: { _ in info.createFolderHandler?() }
            )
        )
        
        let menu = UIMenu(title: C.courseFolderPickerTitle, children: menuItems)
        self.menu = menu
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
