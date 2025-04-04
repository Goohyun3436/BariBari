//
//  CreateFolderViewController.swift
//  BariBari
//
//  Created by Goo on 4/4/25.
//

import UIKit
import RxSwift
import RxCocoa

class CreateFolderViewController: BaseViewController {
    
    //MARK: - Property
    private let mainView = CreateFolderView()
    private let viewModel: CreateFolderViewModel
    private let disposeBag = DisposeBag()
    
    //MARK: - Initializer Method
    init(viewModel: CreateFolderViewModel) {
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
        let input = CreateFolderViewModel.Input(
            title: mainView.titleField.textField.rx.text,
            cancelTap: mainView.cancelButton.rx.tap,
            saveTap: mainView.saveButton.rx.tap
        )
//        let output = viewModel.transform(input: input)
    }
    
}
