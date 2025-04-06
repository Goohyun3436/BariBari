//
//  BaseCollectionViewCell+Ex.swift
//  BariBari
//
//  Created by Goo on 4/6/25.
//

import UIKit

extension BaseCollectionViewCell {
    
    func startJiggling() {
        let animation = CAKeyframeAnimation(keyPath: "transform.rotation")
        animation.values = [-0.05, 0.05, -0.05]
        animation.keyTimes = [0, 0.5, 1]
        animation.duration = 0.4
        animation.repeatCount = Float.infinity
        animation.isRemovedOnCompletion = false
        layer.add(animation, forKey: "jiggle")
    }
    
    func stopJiggling() {
        layer.removeAnimation(forKey: "jiggle")
    }
    
}
