//
//  CreateFormViewController.swift
//  BariBari
//
//  Created by Goo on 4/3/25.
//

import UIKit
import PhotosUI
import RxSwift
import RxCocoa
import RxGesture
import IQKeyboardManagerSwift

final class CreateFormViewController: BaseViewController {
    
    //MARK: - Property
    private let mainView = CreateFormView()
    private let viewModel: CreateFormViewModel
    private let disposeBag = DisposeBag()
    
    private let imagePickerDidFinish = PublishRelay<[PHPickerResult]>()
    
    //MARK: - Initializer Method
    init(viewModel: CreateFormViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    //MARK: - Override Method
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        IQKeyboardManager.shared.disabledDistanceHandlingClasses.append(CreateFormViewController.self)
    }
    
    //MARK: - Setup Method
    override func setupBind() {
        let input = CreateFormViewModel.Input(
            viewWillAppear: rx.viewWillAppear,
            image: imagePickerDidFinish,
            title: mainView.titleField.textField.rx.text,
            content: mainView.contentField.textView.rx.text,
            imageTap: mainView.imageField.rx.anyGesture(.tap()),
            quitTap: mainView.quitButton.rx.tap,
            saveTap: mainView.saveButton.rx.tap
        )
        let output = viewModel.transform(input: input)
        
        output.courseFolderPickerItems
            .bind(with: self) { owner, info in
                owner.mainView.folderPicker.setMenu(info)
            }
            .disposed(by: disposeBag)
        
        output.courseFolderTitle
            .bind(to: mainView.folderPicker.rx.title())
            .disposed(by: disposeBag)
        
        output.image
            .bind(to: mainView.imageField.imageView.rx.image)
            .disposed(by: disposeBag)
        
        output.title
            .bind(to: mainView.titleField.textField.rx.text)
            .disposed(by: disposeBag)
        
        output.content
            .bind(to: mainView.contentField.textView.rx.text)
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
        
        output.rootTBC
            .bind(with: self) { owner, _ in
                owner.rootTBC()
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

extension CreateFormViewController: PHPickerViewControllerDelegate {
    
    func picker(
        _ picker: PHPickerViewController,
        didFinishPicking results: [PHPickerResult]
    ) {
        picker.dismiss(animated: true)
        imagePickerDidFinish.accept(results)
    }
    
}
