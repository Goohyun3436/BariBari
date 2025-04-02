//
//  CreateTrackingViewController.swift
//  BariBari
//
//  Created by Goo on 4/2/25.
//

import UIKit
import RxSwift
import RxCocoa

final class CreateTrackingViewController: BaseViewController {
    
    //MARK: - Property
    private let mainView = CreateTrackingView()
    private let viewModel = CreateTrackingViewModel()
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
        let input = CreateTrackingViewModel.Input(
            startTap: mainView.startButton.rx.tap,
            menuTap: mainView.trackingBar.menuButton.rx.tap
        )
        let output = viewModel.transform(input: input)
        
        output.titleText
            .bind(to: mainView.trackingBar.titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.isTracking
            .bind(with: self) { owner, isTracking in
                owner.mainView.setTrackingMode(isTracking)
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
