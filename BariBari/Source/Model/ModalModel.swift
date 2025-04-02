//
//  ModalModel.swift
//  BariBari
//
//  Created by Goo on 4/2/25.
//

import Foundation

struct ModalInfo {
    var title: String
    var message: String
    var cancelButtonTitle: String = "취소"
    var submitButtonTitle: String = "확인"
    var cancelHandler: (() -> Void)? = nil
    var submitHandler: (() -> Void)? = nil
}
