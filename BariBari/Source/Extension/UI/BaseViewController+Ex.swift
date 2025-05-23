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
    
    func presentVC(_ vc: BaseViewController, isEmbedNav: Bool = false) {
        if isEmbedNav {
            present(UINavigationController(rootViewController: vc), animated: true)
        } else {
            present(vc, animated: true)
        }
    }
    
    func presentVC(_ vc: BaseViewController, detents: CGFloat, grabber: Bool = false) {
        if let sheet = vc.sheetPresentationController {
            let customDetent = UISheetPresentationController.Detent.custom { context in
                return context.maximumDetentValue * detents
            }
            sheet.detents = [customDetent]
            sheet.prefersGrabberVisible = grabber
        }
        presentVC(vc)
    }
    
    func presentFormVC(_ vc: BaseViewController) {
        if let sheet = vc.sheetPresentationController {
            let customDetent = UISheetPresentationController.Detent.custom { context in
                return 90
            }
            sheet.prefersGrabberVisible = true
            sheet.detents = [customDetent, .medium(), .large()]
            sheet.selectedDetentIdentifier = .medium
            sheet.largestUndimmedDetentIdentifier = .medium
        }
        vc.isModalInPresentation = true
        presentVC(vc)
    }
    
    func presentModalVC(_ vc: BaseViewController) {
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        presentVC(vc)
    }
    
    func dismissVC() {
        dismiss(animated: true)
    }
    
    func rootVC(_ vc: BaseViewController) {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = scene.windows.first
        else { return }
        
        window.rootViewController = vc
    }
    
    func rootTBC() {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = scene.windows.first
        else { return }
        
        window.rootViewController = TabBarController()
    }
    
}

//MARK: - Alert
extension BaseViewController {
    
    func presentActionSheet(_ items: [ActionSheetInfo]) {
        let alert = UIAlertController(
            title: nil,
            message: nil,
            preferredStyle: .actionSheet
        )
        
        items.forEach { item in
            alert.addAction(
                UIAlertAction(
                    title: item.title,
                    style: .default,
                    handler: { _ in item.handler() }
                )
            )
        }
        
        alert.addAction(
            UIAlertAction(title: C.cancelTitle, style: .cancel) { _ in
                alert.dismiss(animated: true)
            }
        )
        
        present(alert, animated: true, completion: nil)
    }
    
}
