//
//  EntireCourseViewController.swift
//  BariBari
//
//  Created by Goo on 4/2/25.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture

final class EntireCourseViewController: BaseViewController {
    
    //MARK: - Property
    private let mainView = EntireCourseView()
    private let viewModel = EntireCourseViewModel()
    private let disposeBag = DisposeBag()
    
    //MARK: - Override Method
    override func loadView() {
        view = mainView
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: mainView.deleteButton)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - Setup Method
    override func setupBind() {
        let input = EntireCourseViewModel.Input(
            viewWillAppear: rx.viewWillAppear,
            deleteTap: mainView.deleteButton.rx.tap,
            courseFolderLongPress: mainView.collectionView.rx.longPressGesture(),
            courseFolderTap: mainView.collectionView.rx.modelSelected(CourseFolder.self)
        )
        let output = viewModel.transform(input: input)
        
        let isEditing = output.isEditing.share(replay: 1)
        let noneContentVisible = output.noneContentVisible.share(replay: 1)
        
        output.courseFolders
            .bind(
                to: mainView.collectionView.rx.items(
                    cellIdentifier: CircleImageCollectionViewCell.id,
                    cellType: CircleImageCollectionViewCell.self
                ),
                curriedArgument: { item, element, cell in
                    cell.setData(
                        image: element.image,
                        title: element.title,
                        subText: element.courseCount
                    )
                    
                    cell.isEditing = output.isEditing.value
                }
            )
            .disposed(by: disposeBag)
        
        noneContentVisible
            .bind(to: mainView.noneContentView.rx.isHidden)
            .disposed(by: disposeBag)
        
        noneContentVisible
            .map { !$0 }
            .bind(to: mainView.deleteButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        isEditing
            .bind(to: mainView.deleteButton.rx.isSelected)
            .disposed(by: disposeBag)
        
        isEditing
            .bind(with: self) { owner, _ in
                owner.mainView.collectionView.reloadData()
            }
            .disposed(by: disposeBag)
        
        output.presentModalVC
            .bind(with: self) { owner, vc in
                owner.presentModalVC(vc)
            }
            .disposed(by: disposeBag)
        
        output.dismissVC
            .bind(with: self) { owner, _ in
                owner.dismissVC()
            }
            .disposed(by: disposeBag)
        
        output.pushVC
            .bind(with: self) { owner, vc in
                owner.pushVC(vc)
            }
            .disposed(by: disposeBag)
    }
    
}
