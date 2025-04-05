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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - Setup Method
    override func setupBind() {
        let input = CourseDetailViewModel.Input()
        let output = viewModel.transform(input: input)
        
        output.navigationTitle
            .bind(to: rx.title)
            .disposed(by: disposeBag)
        
        output.course
            .bind(with: self) { owner, course in
                owner.mainView.setData(course)
            }
            .disposed(by: disposeBag)
    }
    
}
