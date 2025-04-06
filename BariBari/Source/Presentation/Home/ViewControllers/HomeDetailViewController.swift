//
//  HomeDetailViewController.swift
//  BariBari
//
//  Created by Goo on 4/2/25.
//

import UIKit
import RxSwift
import RxCocoa

final class HomeDetailViewController: BaseViewController {
    
    //MARK: - Property
    private let mainView = HomeDetailView()
    private let viewModel: HomeDetailViewModel
    private let disposeBag = DisposeBag()
    
    //MARK: - Initializer Method
    init(viewModel: HomeDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    //MARK: - Override Method
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - Setup Method
    override func setupBind() {
        let input = HomeDetailViewModel.Input(
            viewDidLoad: rx.viewDidLoad,
            mapButtonTap: mainView.mapThumbnailView.mapButton.rx.tap
        )
        let output = viewModel.transform(input: input)
        
        output.navigationTitle
            .bind(to: rx.title)
            .disposed(by: disposeBag)
        
        output.course
            .bind(with: self) { owner, course in
                owner.mainView.setData(course)
            }
            .disposed(by: disposeBag)
        
        output.presentVC
            .bind(with: self) { owner, info in
                owner.presentVC(info.vc, detents: info.detents)
            }
            .disposed(by: disposeBag)
        
        output.dismissVC
            .bind(with: self) { owner, _ in
                owner.dismissVC()
            }
            .disposed(by: disposeBag)
    }
    
}
