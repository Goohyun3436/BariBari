//
//  EntireCourseViewController.swift
//  BariBari
//
//  Created by Goo on 4/2/25.
//

import UIKit
import RxSwift
import RxCocoa

final class EntireCourseViewController: BaseViewController {
    
    //MARK: - Property
    private let mainView = EntireCourseView()
    private let viewModel = EntireCourseViewModel()
    private let disposeBag = DisposeBag()
    
    //MARK: - Override Method
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - Setup Method
    override func setupBind() {}
    
}
