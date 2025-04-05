//
//  EntireCourseViewController.swift
//  BariBari
//
//  Created by Goo on 4/2/25.
//

import UIKit
import RxSwift
import RxCocoa

final class EntireCourseViewController: BaseViewController {
    
    //MARK: - Property
    private let mainView = EntireCourseView()
    private let viewModel = EntireCourseViewModel()
    private let disposeBag = DisposeBag()
    
    //MARK: - Override Method
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - Setup Method
    override func setupBind() {
        let input = EntireCourseViewModel.Input(
            viewWillAppear: rx.viewWillAppear,
            courseFolderTap: mainView.collectionView.rx.modelSelected(CourseFolder.self)
        )
        let output = viewModel.transform(input: input)
        
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
                }
            )
            .disposed(by: disposeBag)
        
        output.noneContentVisible
            .bind(to: mainView.noneContentView.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.pushVC
            .bind(with: self) { owner, vc in
                owner.pushVC(vc)
            }
            .disposed(by: disposeBag)
    }
    
}
