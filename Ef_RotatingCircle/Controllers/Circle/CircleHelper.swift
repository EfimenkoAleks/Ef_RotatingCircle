//
//  CircleHelper.swift
//  Ef_RotatingCircle
//
//  Created by Aleksandr on 07.02.2024.
//

import UIKit

class CircleHelper: NSObject {
    
    func rotationRoundV(roundedView: UIView) {
        UIView.animate(withDuration: 3.0, delay: 0.0, options: .curveLinear) {
            roundedView.transform = CGAffineTransform.identity
            roundedView.transform = CGAffineTransform(rotationAngle: CGFloat.pi * 0.999)
        } completion: { _ in
            UIView.animate(withDuration: 3.0, delay: 0.0, options: .curveLinear) { 

                roundedView.transform = CGAffineTransform(rotationAngle: CGFloat.pi * 0.999 * 2)
            } completion: { [weak self] _ in
                guard let self = self else { return }
                self.rotationRoundV(roundedView: roundedView)
            }
        }
    }
    
    func addDynamicBehaviorForItem(_ items: [UIView]) -> UIDynamicItemBehavior {
        let behavior = UIDynamicItemBehavior(items: items)
        behavior.resistance = 6
        behavior.allowsRotation = false
       
        return behavior
    }
    
    func addDynamicBehaviorForRound(_ items: [UIView]) -> UIDynamicItemBehavior {
        let behavior = UIDynamicItemBehavior(items: items)
        behavior.addAngularVelocity(1, for: items.first!)
        behavior.resistance = 0
        behavior.angularResistance = 0
        behavior.allowsRotation = true
        behavior.isAnchored = true
        
        return behavior
    }
}
