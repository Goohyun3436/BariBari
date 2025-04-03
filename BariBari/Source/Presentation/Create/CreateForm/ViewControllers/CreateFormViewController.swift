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
    
    deinit {
        print(self, #function)
    }
    
    //MARK: - Setup Method
    override func setupBind() {
        let input = CreateFormViewModel.Input(
            title: mainView.titleField.textField.rx.text,
            content: mainView.contentField.textView.rx.text,
            quitTap: mainView.quitButton.rx.tap,
            saveTap: mainView.saveButton.rx.tap
        )
        let output = viewModel.transform(input: input)
        
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
        
        output.rootTBC
            .bind(with: self) { owner, _ in
                owner.rootTBC()
            }
            .disposed(by: disposeBag)
    }
    
}
