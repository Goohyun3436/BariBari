//
//  SectionModel.swift
//  BariBari
//
//  Created by Goo on 4/21/25.
//

import RxDataSources

struct SectionModel {
    var header: String
    var items: [ItemModel]
}

extension SectionModel: SectionModelType {
    init(original: SectionModel, items: [ItemModel]) {
        self = original
        self.items = items
    }
}

struct ItemModel {
    let icon: AppIcon
    let title: String
    var subText: String? = nil
    var isMoreIcon: Bool = false
}
