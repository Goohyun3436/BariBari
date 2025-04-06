//
//  CreateFolderViewController.swift
//  BariBari
//
//  Created by Goo on 4/4/25.
//

import UIKit
import PhotosUI
import RxSwift
import RxCocoa
import RxGesture

final class CreateFolderViewController: BaseViewController {
    
    //MARK: - Property
    private let mainView = CreateFolderView()
    private let viewModel: CreateFolderViewModel
    private let disposeBag = DisposeBag()
    private let imagePickerDidFinish = PublishRelay<[PHPickerResult]>()
    
    //MARK: - Initializer Method
    init(viewModel: CreateFolderViewModel) {
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
        let input = CreateFolderViewModel.Input(
            image: imagePickerDidFinish,
            title: mainView.titleField.textField.rx.text,
            imageTap: mainView.imageField.rx.anyGesture(.tap()),
            cancelTap: mainView.cancelButton.rx.tap,
            saveTap: mainView.saveButton.rx.tap
        )
        let output = viewModel.transform(input: input)
        
        output.image
            .bind(to: mainView.imageField.imageView.rx.image)
            .disposed(by: disposeBag)
        
        output.presentImagePickerVC
            .bind(with: self) { owner, _ in
                owner.presentImagePickerVC()
            }
            .disposed(by: disposeBag)
        
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
    }
    
    private func presentImagePickerVC() {
        var config = PHPickerConfiguration()
        config.filter = .any(of: [.screenshots, .images])
        config.selectionLimit = 1
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true)
    }
    
}

extension CreateFolderViewController: PHPickerViewControllerDelegate {
    
    func picker(
        _ picker: PHPickerViewController,
        didFinishPicking results: [PHPickerResult]
    ) {
        picker.dismiss(animated: true)
        imagePickerDidFinish.accept(results)
    }
    
}
