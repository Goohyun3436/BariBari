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
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - Setup Method
    override func setupBind() {}
    
}
