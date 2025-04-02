//
//  CreateTrackingViewController.swift
//  BariBari
//
//  Created by Goo on 4/2/25.
//

import UIKit
import MapKit
import RxSwift
import RxCocoa

final class CreateTrackingViewController: BaseViewController {
    
    //MARK: - Property
    private let mainView = CreateTrackingView()
    private let viewModel = CreateTrackingViewModel()
    private let disposeBag = DisposeBag()
    
    //MARK: - Override Method
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.mapView.delegate = self
    }
    
    //MARK: - Setup Method
    override func setupBind() {
        let input = CreateTrackingViewModel.Input(
            viewDidLoad: rx.viewDidLoad,
            startTap: mainView.startButton.rx.tap,
            menuTap: mainView.trackingBar.menuButton.rx.tap
        )
        let output = viewModel.transform(input: input)
        
        output.titleText
            .bind(to: mainView.trackingBar.titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.trackingStatus
            .bind(with: self) { owner, status in
                owner.mainView.setTrackingStatus(status)
            }
            .disposed(by: disposeBag)
        
        output.clearRoute
            .bind(with: self) { owner, _ in
                owner.mainView.mapView.clearRoute()
            }
            .disposed(by: disposeBag)
        
        output.updateRegion
            .bind(with: self) { owner, coord in
                owner.mainView.mapView.updateRegion(to: coord)
            }
            .disposed(by: disposeBag)
        
        output.addPoint
            .bind(with: self) { owner, coord in
                owner.mainView.mapView.addPoint(at: coord)
            }
            .disposed(by: disposeBag)
        
        output.distance
            .bind(to: mainView.trackingBar.distanceLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.drawCompletedRoute
            .bind(with: self) { owner, _ in
                owner.mainView.mapView.drawCompletedRoute()
            }
            .disposed(by: disposeBag)
        
        output.presentVC
            .bind(with: self) { owner, info in
                owner.presentVC(info.vc, detents: info.detents)
            }
            .disposed(by: disposeBag)
        
        output.presentFormVC
            .bind(with: self) { owner, vc in
                owner.presentFormVC(vc)
            }
            .disposed(by: disposeBag)
        
        output.dismissVC
            .bind(with: self) { owner, _ in
                owner.dismissVC()
            }
            .disposed(by: disposeBag)
    }
    
}

// MARK: - MKMapViewDelegate
extension CreateTrackingViewController: MKMapViewDelegate {
    
    func mapView(
        _ mapView: MKMapView,
        rendererFor overlay: MKOverlay
    ) -> MKOverlayRenderer {
        return mainView.mapView.makePolylineOverlay(with: overlay)
    }
    
    func mapView(
        _ mapView: MKMapView,
        viewFor annotation: MKAnnotation
    ) -> MKAnnotationView? {
        return mainView.mapView.makeAnnotationView(with: annotation)
    }
    
}
