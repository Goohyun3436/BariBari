//
//  BaseViewController.swift
//  BariBari
//
//  Created by Goo on 3/29/25.
//

import UIKit

//MARK: - Transition
extension BaseViewController {
    
    func pushVC(_ vc: BaseViewController) {
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func popVC() {
        navigationController?.popViewController(animated: true)
    }
    
    func presentVC(_ vc: BaseViewController) {
        present(vc, animated: true)
    }
    
    func dismissVC() {
        dismiss(animated: true)
    }
    
    func rootVC(_ vc: BaseViewController) {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = scene.windows.first
        else { return }

        window.rootViewController = UINavigationController(rootViewController: vc)
    }
    
}
