//
//  CourseDetailViewController.swift
//  BariBari
//
//  Created by Goo on 4/2/25.
//

import UIKit
import RxSwift
import RxCocoa

final class CourseDetailViewController: BaseViewController {
    
    //MARK: - Property
    private let mainView = CourseDetailView()
    private let viewModel: CourseDetailViewModel
    private let disposeBag = DisposeBag()
    
    //MARK: - Initializer Method
    init(viewModel: CourseDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    //MARK: - Override Method
    override func loadView() {
        view = mainView
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(customView: mainView.deleteButton),
            UIBarButtonItem(customView: mainView.editButton)
        ]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - Setup Method
    override func setupBind() {
        let input = CourseDetailViewModel.Input(
            viewDidLoad: rx.viewDidLoad,
            editTap: mainView.editButton.rx.tap,
            deleteTap: mainView.deleteButton.rx.tap,
            mapButtonTap: mainView.mapThumbnailView.mapButton.rx.tap
        )
        let output = viewModel.transform(input: input)
        
        let isEditing = output.isEditing.share(replay: 1)
        
        output.navigationTitle
            .bind(to: rx.title)
            .disposed(by: disposeBag)
        
        output.course
            .bind(with: self) { owner, course in
                owner.mainView.setData(course)
            }
            .disposed(by: disposeBag)
        
        output.mapThumbnail
            .bind(with: self) { owner, info in
                owner.mainView.mapThumbnailView.setData(info.address, info.pins)
            }
            .disposed(by: disposeBag)
        
        isEditing
            .map { !$0 }
            .bind(to: mainView.editButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        isEditing
            .map { !$0 }
            .bind(to: mainView.deleteButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        isEditing
            .bind(to: navigationItem.rx.hidesBackButton)
            .disposed(by: disposeBag)
        
        output.presentVC
            .bind(with: self) { owner, info in
                owner.presentVC(info.vc, detents: info.detents)
            }
            .disposed(by: disposeBag)
        
        output.presentFormVC
            .bind(with: self) { owner, vc in
                owner.presentFormVC(vc)
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
        
        output.popVC
            .bind(with: self) { owner, vc in
                owner.popVC()
            }
            .disposed(by: disposeBag)
    }
    
}
