//
//  CreateFormViewController.swift
//  BariBari
//
//  Created by Goo on 4/3/25.
//

import UIKit
import RxSwift
import RxCocoa

final class CreateFormViewController: BaseViewController {
    
    //MARK: - Property
    private let mainView = CreateFormView()
    private let viewModel: CreateFormViewModel
    private let disposeBag = DisposeBag()
    
    //MARK: - Initializer Method
    init(viewModel: CreateFormViewModel) {
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
        let input = CreateFormViewModel.Input(
            title: mainView.titleField.textField.rx.text,
            content: mainView.contentField.textView.rx.text,
            cancelTap: mainView.cancelButton.rx.tap,
            submitTap: mainView.submitButton.rx.tap
        )
        let output = viewModel.transform(input: input)
    }
    
}
