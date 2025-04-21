//
//  AboutViewController.swift
//  BariBari
//
//  Created by Goo on 4/21/25.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

final class AboutViewController: BaseViewController {
    
    //MARK: - Property
    private let mainView = AboutView()
    private let viewModel = AboutViewModel()
    private let disposeBag = DisposeBag()
    
    //MARK: - Override Method
    override func loadView() {
        view = mainView
        navigationItem.backBarButtonItem = UIBarButtonItem(customView: mainView.quitButton)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - Setup Method
    override func setupBind() {
        let input = AboutViewModel.Input(
            
        )
        let output = viewModel.transform(input: input)
        
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
    }
    
}
