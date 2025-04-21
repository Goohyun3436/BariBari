//
//  HomeViewController.swift
//  BariBari
//
//  Created by Goo on 4/2/25.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture

final class HomeViewController: BaseViewController {
    
    //MARK: - Property
    private let mainView = HomeView()
    private let viewModel = HomeViewModel()
    private let disposeBag = DisposeBag()
    
    //MARK: - Override Method
    override func loadView() {
        view = mainView
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: mainView.moreButton)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - Setup Method
    override func setupBind() {
        let input = HomeViewModel.Input(
            viewDidLoad: rx.viewDidLoad,
            moreTap: mainView.moreButton.rx.tap,
            bannerTap: mainView.bannerView.rx.anyGesture(.tap()),
            courseTap: mainView.collectionView.rx.modelSelected(Course.self)
        )
        let output = viewModel.transform(input: input)
        
        output.bannerCourse
            .bind(with: self) { owner, course in
                owner.mainView.bannerView.setData(
                    image: course.image,
                    imageUrl: course.imageUrl,
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
                        imageUrl: element.imageUrl,
                        title: element.title,
                        subText: element.address
                    )
                }
            )
            .disposed(by: disposeBag)
        
        output.presentActionSheet
            .bind(with: self) { owner, items in
                owner.presentActionSheet(items)
            }
            .disposed(by: disposeBag)
        
        output.presentVC
            .bind(with: self) { owner, vc in
                owner.presentVC(vc)
            }
            .disposed(by: disposeBag)
        
        output.pushVC
            .bind(with: self) { owner, vc in
                owner.pushVC(vc)
            }
            .disposed(by: disposeBag)
    }
    
}
