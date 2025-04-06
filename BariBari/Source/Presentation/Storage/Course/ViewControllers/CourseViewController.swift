//
//  CourseViewController.swift
//  BariBari
//
//  Created by Goo on 4/2/25.
//

import UIKit
import RxSwift
import RxCocoa

final class CourseViewController: BaseViewController {
    
    //MARK: - Property
    private let mainView = CourseView()
    private let viewModel: CourseViewModel
    private let disposeBag = DisposeBag()
    
    //MARK: - Initializer Method
    init(viewModel: CourseViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    //MARK: - Override Method
    override func loadView() {
        view = mainView
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: mainView.editButton)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - Setup Method
    override func setupBind() {
        let input = CourseViewModel.Input(
            viewWillAppear: rx.viewWillAppear,
            editTap: mainView.editButton.rx.tap,
            courseTap: mainView.collectionView.rx.modelSelected(Course.self)
        )
        let output = viewModel.transform(input: input)
        
        output.navigationTitle
            .bind(to: rx.title)
            .disposed(by: disposeBag)
        
        output.courses
            .bind(
                to: mainView.collectionView.rx.items(
                    cellIdentifier: HorizontalCollectionViewCell.id,
                    cellType: HorizontalCollectionViewCell.self
                ),
                curriedArgument: { item, element, cell in
                    cell.setData(
                        image: element.image,
                        title: element.title,
                        subText: element.address,
                        content: element.content,
                        date: element.date
                    )
                }
            )
            .disposed(by: disposeBag)
        
        output.noneContentVisible
            .bind(to: mainView.noneContentView.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.isEditing
            .bind(to: mainView.editButton.rx.isSelected)
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
