//
//  CreateListViewController.swift
//  BariBari
//
//  Created by Goo on 4/2/25.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture

final class CreateListViewController: BaseViewController {
    
    //MARK: - Property
    private let mainView = CreateListView()
    private let viewModel = CreateListViewModel()
    private let disposeBag = DisposeBag()
    
    //MARK: - Override Method
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        rootVC(CreateTrackingViewController())
//    }
    
    //MARK: - Setup Method
    override func setupBind() {
        let input = CreateListViewModel.Input(
            trackingCardTap: mainView.trackingCard.rx.tapGesture(),
            autoTap: mainView.autoCard.rx.tapGesture()
        )
        let output = viewModel.transform(input: input)
        
        output.rootVC
            .bind(with: self) { owner, vc in
                owner.rootVC(vc)
            }
            .disposed(by: disposeBag)
    }
    
}
