//
//  MapPickerViewController.swift
//  BariBari
//
//  Created by Goo on 4/5/25.
//

import UIKit
import RxSwift
import RxCocoa

final class MapPickerViewController: BaseViewController {
    
    //MARK: - Property
    private let mainView = MapPickerView()
    private let viewModel: MapPickerViewModel
    private let disposeBag = DisposeBag()
    
    //MARK: - Initializer Method
    init(viewModel: MapPickerViewModel) {
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
        let input = MapPickerViewModel.Input(
            naverMapTap: mainView.naverMap.button.rx.tap
        )
        _ = viewModel.transform(input: input)
    }
    
}
