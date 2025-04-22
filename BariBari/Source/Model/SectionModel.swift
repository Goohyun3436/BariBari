//
//  SectionModel.swift
//  BariBari
//
//  Created by Goo on 4/21/25.
//

import Foundation
import RxDataSources

struct SectionModel: Equatable {
    var header: String
    var items: [ItemModel]
}

extension SectionModel: SectionModelType {
    init(original: SectionModel, items: [ItemModel]) {
        self = original
        self.items = items
    }
}

struct ItemModel: Equatable {
    let icon: AppIcon
    let title: String
    var subText: String? = nil
    var url: URL? = nil
    var isMoreIcon: Bool = false
}
