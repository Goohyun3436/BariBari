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
        
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = AppColor.lightGray.value
        config.baseForegroundColor = AppColor.black.value
        
        var attributedTitle = AttributedString(C.courseFolderPickerTitle)
        attributedTitle.font = AppFont.text1.value
        config.attributedTitle = attributedTitle
        
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 9)
        let arrowImage = UIImage(systemName: AppIcon.arrowDown.value, withConfiguration: imageConfig)?
            .withTintColor(AppColor.black.value, renderingMode: .alwaysOriginal)
        config.image = arrowImage
        config.imagePlacement = .trailing
        config.imagePadding = 4
        
        config.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10)
        config.cornerStyle = .medium
        
        configuration = config
    }
    
    func setMenu(_ info: ( //refactor handler 대신 observer로 selectedElement 관리
        items: [CourseFolder],
        completionHandler: ((CourseFolder) -> Void)?
    )) {
        let menuItems: [UIAction] = info.items.reversed().map { item in
            UIAction(title: item.title, handler: { _ in info.completionHandler?(item) })
        }
        let menu = UIMenu(title: C.courseFolderPickerTitle, children: menuItems)
        self.menu = menu
    }
    
    func setMenu(_ info: ( //refactor handler 대신 observer로 selectedElement 관리
        items: [String],
        completionHandler: (() -> Void)?
    )) {
        let menuItems: [UIAction] = info.items.reversed().map {
            UIAction(title: $0, handler: { _ in info.completionHandler?() })
        }
        let menu = UIMenu(title: C.courseFolderPickerTitle, children: menuItems)
        self.menu = menu
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
