//
//  SettingViewController.swift
//  BariBari
//
//  Created by Goo on 4/22/25.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

final class SettingViewController: BaseViewController {
    
    //MARK: - Property
    private let mainView = SettingView()
    private let viewModel = SettingViewModel()
    private let disposeBag = DisposeBag()
    
    //MARK: - Override Method
    override func loadView() {
        view = mainView
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: mainView.quitButton)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - Setup Method
    override func setupBind() {
        let input = SettingViewModel.Input(
            quitTap: mainView.quitButton.rx.tap,
            itemTap: mainView.tableView.rx.itemSelected
        )
        let output = viewModel.transform(input: input)
        
        output.navigationTitle
            .bind(to: rx.title)
            .disposed(by: disposeBag)
        
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel> { _, tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(
                withIdentifier: BasicTableViewCell.id,
                for: indexPath
            ) as! BasicTableViewCell
            cell.setData(item)
            return cell
        } titleForHeaderInSection: { dataSource, index in
            return dataSource.sectionModels[index].header
        }
        
        output.sections
            .bind(to: mainView.tableView.rx.items(dataSource: dataSource))
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
    
}
