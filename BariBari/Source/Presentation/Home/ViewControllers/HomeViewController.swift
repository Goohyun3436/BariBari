//
//  HomeViewController.swift
//  BariBari
//
//  Created by Goo on 4/2/25.
//

import UIKit
import RxSwift
import RxCocoa

final class HomeViewController: BaseViewController {
    
    //MARK: - Property
    private let mainView = HomeView()
    private let viewModel = HomeViewModel()
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
        let input = HomeViewModel.Input()
        let output = viewModel.transform(input: input)
        
        output.bannerCourse
            .bind(with: self) { owner, course in
                owner.mainView.bannerView.setData(
                    image: course.image,
                    title: course.title,
                    subText: course.address
                )
            }
            .disposed(by: disposeBag)
        
        output.courses
            .bind(
                to: mainView.collectionView.rx.items(
                    cellIdentifier: CourseCollectionViewCell.id,
                    cellType: CourseCollectionViewCell.self
                ),
                curriedArgument: { item, element, cell in
                    cell.setData(
                        image: element.image,
                        title: element.title,
                        subText: element.address
                    )
                }
            )
            .disposed(by: disposeBag)
    }
    
}
