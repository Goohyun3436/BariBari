//
//  CreateViewController.swift
//  BariBari
//
//  Created by Goo on 4/2/25.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture

final class CreateViewController: BaseViewController {
    
    //MARK: - Property
    private let mainView = CreateView()
    private let viewModel = CreateViewModel()
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
        let input = CreateViewModel.Input(
            trackingCardTap: mainView.trackingCard.rx.tapGesture(),
            autoTap: mainView.autoCard.rx.tapGesture()
        )
        let output = viewModel.transform(input: input)
        
        output.pushVC
            .bind(with: self) { owner, vc in
                owner.pushVC(vc)
            }
            .disposed(by: disposeBag)
    }
    
}
