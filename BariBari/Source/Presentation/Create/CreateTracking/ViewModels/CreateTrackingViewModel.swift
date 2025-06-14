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
import RxGesture

final class CreateTrackingViewModel: BaseViewModel {
    
    //MARK: - Input
    struct Input {
        let viewDidLoad: ControlEvent<Void>
        let viewWillAppear: ControlEvent<Void>
        let viewWillDisappear: ControlEvent<Void>
        let userInteraction: Observable<Bool>
        let quitTap: ControlEvent<Void>
        let startTap: ControlEvent<Void>
        let menuTap: ControlEvent<RxGestureRecognizer>
    }
    
    //MARK: - Output
    struct Output {
        let titleText: Observable<String>
        let trackingStatus: BehaviorRelay<CreateTrackingStatus>
        let clearRoute: PublishRelay<Void>
        let updateRegion: PublishRelay<CLLocationCoordinate2D>
        let addPoint: PublishRelay<CLLocationCoordinate2D>
        let drawLineBetween: PublishRelay<(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D)>
        let distance: BehaviorRelay<String>
        let drawCompletedRoute: PublishRelay<[CLLocationCoordinate2D]>
        let presentVC: PublishRelay<(vc: BaseViewController, detents: CGFloat)>
        let presentFormVC: PublishRelay<BaseViewController>
        let dismissVC: PublishRelay<Void>
        let rootTBC: PublishRelay<Void>
    }
    
    //MARK: - Private
    private struct Private {
        let pendingTime = 10
        let isUserInteracting = BehaviorRelay<Bool>(value: false)
        let disposeBag = DisposeBag()
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
        let drawLineBetween = PublishRelay<(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D)>()
        let distance = BehaviorRelay<String>(value: C.distancePlaceholder)
        let drawCompletedRoute = PublishRelay<[CLLocationCoordinate2D]>()
        let presentVC = PublishRelay<(vc: BaseViewController, detents: CGFloat)>()
        let presentFormVC = PublishRelay<BaseViewController>()
        let dismissVC = PublishRelay<Void>()
        let rootTBC = PublishRelay<Void>()
        
        let userInteraction = input.userInteraction
            .filter { LocationManager.shared.isTracking.value && $0 }
            .share(replay: 1)
        
        let quitTap = input.quitTap.share(replay: 1)
        let startTap = input.startTap.share(replay: 1)
        
        input.viewDidLoad
            .filter { LocationManager.shared.requestLocation() }
            .bind(with: self) { owner, _ in
                UIApplication.shared.isIdleTimerDisabled = true
                LocationManager.shared.trigger()
            }
            .disposed(by: priv.disposeBag)
        
        input.viewWillAppear
            .bind(with: self) { owner, _ in
                UIApplication.shared.isIdleTimerDisabled = true
            }
            .disposed(by: priv.disposeBag)
        
        input.viewWillDisappear
            .bind(with: self) { owner, _ in
                UIApplication.shared.isIdleTimerDisabled = false
            }
            .disposed(by: priv.disposeBag)
        
        LocationManager.shared.observeLocationUpdates()
            .bind(with: self) { owner, locations in
                guard let location = locations.last else { return }
                
                // 지도 중심 업데이트
                if !owner.priv.isUserInteracting.value {
                    updateRegion.accept(location.coordinate)
                }
                
                // 지도에 점 추가
                addPoint.accept(location.coordinate)
                
                let coordinates = LocationManager.shared.trackingCoordinates.value
                if coordinates.count > 1 {
                    let from = coordinates[coordinates.count - 2]
                    let to = coordinates[coordinates.count - 1]
                    drawLineBetween.accept((from, to))
                }
            }
            .disposed(by: priv.disposeBag)
        
        LocationManager.shared.observeTotalDistance()
            .map { NumberFormatManager.shared.formatted($0 * 0.001) + "km" }
            .bind(to: distance)
            .disposed(by: priv.disposeBag)
        
        userInteraction
            .bind(to: priv.isUserInteracting)
            .disposed(by: priv.disposeBag)
        
        userInteraction
            .withLatestFrom(Observable<Int>.just(priv.pendingTime))
            .flatMapLatest {
                Observable<Int>.timer(.seconds($0), scheduler: MainScheduler.instance)
            }
            .bind(with: self) { owner, _ in
                owner.priv.isUserInteracting.accept(false)
            }
            .disposed(by: priv.disposeBag)
        
        priv.isUserInteracting
            .filter { !$0 }
            .compactMap { _ in
                LocationManager.shared.trackingCoordinates.value.last
            }
            .bind(to: updateRegion)
            .disposed(by: priv.disposeBag)
        
        quitTap
            .map { LocationManager.shared.stopTracking() }
            .bind(to: rootTBC)
            .disposed(by: priv.disposeBag)
        
        startTap
            .filter { LocationManager.shared.requestLocation() }
            .map { CreateTrackingStatus.tracking }
            .bind(to: trackingStatus)
            .disposed(by: priv.disposeBag)
        
        input.menuTap
            .map { _ in
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
                return (vc: vc, detents: C.presentBottomDetents)
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
                    let coords = LocationManager.shared.trackingCoordinates.value
                    drawCompletedRoute.accept(coords)
                    LocationManager.shared.stopTracking()
                    presentFormVC.accept(
                        CreateFormViewController(
                            viewModel: CreateFormViewModel(
                                pins: MapManager.shared.convertToPins(with: coords)
                            )
                        )
                    )
                }
            }
            .disposed(by: priv.disposeBag)
        
        Observable<ActionType>.merge(
            quitTap.map { .createTrackingQuit },
            startTap.map { .createTrackingStart }
        )
        .bind(with: self) { owner, action in
            FirebaseAnalyticsManager.shared.logEventInScreen(
                action: action,
                screen: .createTracking
            )
        }
        .disposed(by: priv.disposeBag)
        
        return Output(
            titleText: titleText,
            trackingStatus: trackingStatus,
            clearRoute: clearRoute,
            updateRegion: updateRegion,
            addPoint: addPoint,
            drawLineBetween: drawLineBetween,
            distance: distance,
            drawCompletedRoute: drawCompletedRoute,
            presentVC: presentVC,
            presentFormVC: presentFormVC,
            dismissVC: dismissVC,
            rootTBC: rootTBC
        )
    }
    
}
