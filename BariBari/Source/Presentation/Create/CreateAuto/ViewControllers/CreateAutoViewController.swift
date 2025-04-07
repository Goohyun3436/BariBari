//
//  CreateAutoViewController.swift
//  BariBari
//
//  Created by Goo on 4/2/25.
//

import UIKit
import RxSwift
import RxCocoa

final class CreateAutoViewController: BaseViewController {
    
    //MARK: - Property
    private let mainView = CreateAutoView()
    private let viewModel = CreateAutoViewModel()
    private let disposeBag = DisposeBag()
    
    //MARK: - Override Method
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - Setup Method
    override func setupBind() {}
    
}
