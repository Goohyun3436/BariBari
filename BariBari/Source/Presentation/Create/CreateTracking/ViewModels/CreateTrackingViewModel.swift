//
//  CreateTrackingViewModel.swift
//  BariBari
//
//  Created by Goo on 4/2/25.
//

import Foundation
import MapKit
import RxSwift
import RxCocoa

final class CreateTrackingViewModel: BaseViewModel {
    
    //MARK: - Input
    struct Input {
        let viewDidLoad: ControlEvent<Void>
        let startTap: ControlEvent<Void>
        let menuTap: ControlEvent<Void>
    }
    
    //MARK: - Output
    struct Output {
        let titleText: Observable<String>
        let trackingStatus: BehaviorRelay<CreateTrackingStatus>
        let clearRoute: PublishRelay<Void>
        let updateRegion: PublishRelay<CLLocationCoordinate2D>
        let addPoint: PublishRelay<CLLocationCoordinate2D>
        let distance: BehaviorRelay<String>
        let drawCompletedRoute: PublishRelay<Void>
        let presentVC: PublishRelay<(vc: BaseViewController, detents: CGFloat)>
        let presentFormVC: PublishRelay<BaseViewController>
        let dismissVC: PublishRelay<Void>
        let rootTBC: PublishRelay<Void>
    }
    
    //MARK: - Private
    private struct Private {
        let locationManager = LocationManager.shared
        let disposeBag = DisposeBag()
    }
    
    deinit {
        print(self, #function)
    }
    
    //MARK: - Property
    private let priv = Private()
    
    //MARK: - Transform
    func transform(input: Input) -> Output {
        let titleText = Observable.just(C.createTrackingTitle)
        let trackingStatus = BehaviorRelay<CreateTrackingStatus>(value: .ready)
        let clearRoute = PublishRelay<Void>()
        let updateRegion = PublishRelay<CLLocationCoordinate2D>()
        let addPoint = PublishRelay<CLLocationCoordinate2D>()
        let distance = BehaviorRelay<String>(value: "0km")
        let drawCompletedRoute = PublishRelay<Void>()
        let presentVC = PublishRelay<(vc: BaseViewController, detents: CGFloat)>()
        let presentFormVC = PublishRelay<BaseViewController>()
        let dismissVC = PublishRelay<Void>()
        let rootTBC = PublishRelay<Void>()
        
        input.viewDidLoad
            .bind(with: self) { owner, _ in
                owner.priv.locationManager.trigger()
            }
            .disposed(by: priv.disposeBag)
        
        priv.locationManager.observeLocationUpdates()
            .bind(with: self) { owner, locations in
                guard let location = locations.last else { return }
                
                // 지도 중심 업데이트
                updateRegion.accept(location.coordinate)
                
                // 지도에 점 추가 & 이전 위치와 현재 위치 사이에 선 그리기
                addPoint.accept(location.coordinate)
            }
            .disposed(by: priv.disposeBag)
        
        priv.locationManager.observeTotalDistance()
            .map { NumberFormatManager.shared.formatted($0 * 0.0001) + "km" }
            .bind(to: distance)
            .disposed(by: priv.disposeBag)
        
        input.startTap
            .map { CreateTrackingStatus.tracking }
            .bind(to: trackingStatus)
            .disposed(by: priv.disposeBag)
        
        input.menuTap
            .map {
                let vc = TrackingModalViewController(
                    viewModel: TrackingModalViewModel(
                        cancelHandler: {
                            dismissVC.accept(())
                        },
                        completeHandler: {
                            dismissVC.accept(())
                            trackingStatus.accept(.complete)
                        }
                    )
                )
                return (vc: vc, detents: 0.15)
            }
            .bind(to: presentVC)
            .disposed(by: priv.disposeBag)
        
        trackingStatus
            .bind(with: self) { owner, status in
                switch status {
                case .ready:
                    print("ready")
                case .tracking:
                    clearRoute.accept(())
                    LocationManager.shared.startTracking()
                case .complete:
                    LocationManager.shared.stopTracking()
                    drawCompletedRoute.accept(())
                    presentFormVC.accept(
                        CreateFormViewController(
                            viewModel: CreateFormViewModel(
                                coords: LocationManager.shared.trackingCoordinates.value
                            )
                        )
                    )
                }
            }
            .disposed(by: priv.disposeBag)
        
        return Output(
            titleText: titleText,
            trackingStatus: trackingStatus,
            clearRoute: clearRoute,
            updateRegion: updateRegion,
            addPoint: addPoint,
            distance: distance,
            drawCompletedRoute: drawCompletedRoute,
            presentVC: presentVC,
            presentFormVC: presentFormVC,
            dismissVC: dismissVC,
            rootTBC: rootTBC
        )
    }
    
}
