//
//  AboutView.swift
//  BariBari
//
//  Created by Goo on 4/21/25.
//

import UIKit
import SnapKit

final class AboutView: BaseView {
    
    //MARK: - UI Property
    let quitButton = IconButton(icon: .xmark)
    let tableView = UITableView(frame: .zero, style: .insetGrouped)
    
    //MARK: - Setup Method
    override func setupUI() {
        tableView.register(
            BasicTableViewCell.self,
            forCellReuseIdentifier: BasicTableViewCell.id
        )
        
        addSubview(tableView)
    }
    
    override func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
    }
    
    override func setupAttributes() {
        backgroundColor = AppColor.lightGray.value
        tableView.separatorStyle = .singleLine
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
    }
    
}
