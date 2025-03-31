//
//  TestViewController.swift
//  BariBari
//
//  Created by Goo on 3/31/25.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class TestViewController: UIViewController {
    
    let button = UIButton()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(button)
        button.snp.makeConstraints { make in
            make.center.equalTo(view.safeAreaLayoutGuide)
            make.size.equalTo(100)
        }
        button.backgroundColor = .red
        
        button.rx.tap
            .bind(with: self, onNext: { owner, _ in
                let coords = [
                    Coord(name: "경유지1", lat: 37.3595953, lng: 127.1053971),
                    Coord(name: "경유지2",lat: 37.464007, lng: 126.9522394),
                    Coord(name: "도착지",lat: 37.4200267, lng: 127.1267772)
                ]
                
                MapManager.shared.openNaverMap(coords: coords)
            })
            .disposed(by: disposeBag)
    }
    
}
