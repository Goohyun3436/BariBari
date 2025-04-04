//
//  ModalViewController.swift
//  BariBari
//
//  Created by Goo on 4/2/25.
//

import UIKit
import RxSwift
import RxCocoa

final class ModalViewController: BaseViewController {
    
    //MARK: - Property
    private let mainView = ModalView()
    private let viewModel: ModalViewModel
    private let disposeBag = DisposeBag()
    
    //MARK: - Initializer Method
    init(viewModel: ModalViewModel) {
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
        let input = ModalViewModel.Input(
            cancelTap: mainView.cancelButton.rx.tap,
            submitTap: mainView.submitButton.rx.tap
        )
        let output = viewModel.transform(input: input)
        
        output.title
            .bind(to: mainView.titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.message
            .bind(to: mainView.messageLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.cancelButtonTitle
            .bind(to: mainView.cancelButton.rx.title())
            .disposed(by: disposeBag)
        
        output.submitButtonTitle
            .bind(to: mainView.submitButton.rx.title())
            .disposed(by: disposeBag)
        
        output.cancelButtonColor
            .bind(with: self) { owner, color in
                owner.mainView.setCancelButtonColor(color)
            }
            .disposed(by: disposeBag)
        
        output.submitButtonColor
            .bind(with: self) { owner, color in
                owner.mainView.setSubmitButtonColor(color)
            }
            .disposed(by: disposeBag)
        
        output.cancelButtonIsHidden
            .bind(to: mainView.cancelButton.rx.isHidden)
            .disposed(by: disposeBag)
    }
    
}
