//
//  TrackingModalViewController.swift
//  BariBari
//
//  Created by Goo on 4/2/25.
//

import UIKit
import RxSwift
import RxCocoa

class TrackingModalViewController: BaseViewController {
    
    //MARK: - Property
    private let mainView = TrackingModalView()
    private let viewModel: TrackingModalViewModel
    private let disposeBag = DisposeBag()
    
    //MARK: - Initializer Method
    init(viewModel: TrackingModalViewModel) {
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
        let input = TrackingModalViewModel.Input(
            quitTap: mainView.quitButton.rx.tap,
            stopTap: mainView.stopButton.rx.tap
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
