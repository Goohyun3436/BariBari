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
    var cancelButtonTitle: String = C.cancelTitle
    var submitButtonTitle: String = C.submitTitle
    var cancelHandler: (() -> Void)? = nil
    var submitHandler: (() -> Void)? = nil
}
