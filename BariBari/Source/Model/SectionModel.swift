//
//  SectionModel.swift
//  BariBari
//
//  Created by Goo on 4/21/25.
//

import Foundation
import RxDataSources

protocol SectionProtocol: CaseIterable {
    var value: SectionModel { get }
}

protocol SectionItemProtocol: CaseIterable {
    static var sectionTitle: String { get }
    var icon: AppIcon { get }
    var title: String { get }
    var subText: String? { get }
    var url: URL? { get }
    var isMoreIcon: Bool { get }
}

enum SectionType {
    static func makeSectionModel<T: SectionItemProtocol>(item: T.Type) -> SectionModel {
        return SectionModel(
            header: item.sectionTitle,
            items: T.allCases.map {
                ItemModel(
                    icon: $0.icon,
                    title: $0.title,
                    subText: $0.subText,
                    url: $0.url,
                    isMoreIcon: $0.isMoreIcon
                )
            }
        )
    }
}

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
