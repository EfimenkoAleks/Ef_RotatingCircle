//
//  LineAnimator.swift
//  Ef_RotatingCircle
//
//  Created by Aleksandr on 05.02.2024.
//

import UIKit

class LineAnimator: NSObject {
    
    var lineView: LineView?
    var handler: (() -> Void)?
    var gravity: UIGravityBehavior?
    var startRect: CGRect?
    private var timer: Timer = Timer()
    
    private func createRandomNumber(completion: @escaping () -> Void) {
        let randomInt = Int.random(in: 1..<4)
        setTimer(time: Double(randomInt)) {
            completion()
        }
    }
    
    private func setTimer(time: Double, completion: @escaping () -> Void) {
        
        timer.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: time, repeats: false) { _ in
            completion()
        }
    }
    
    private func addGravityForItem(_ item: UIView) -> UIGravityBehavior {
        let gravity = UIGravityBehavior()
        gravity.addItem(item)
        gravity.gravityDirection = CGVectorMake(-1,0)
        gravity.magnitude = 0.3
        
        return gravity
    }
    
    func resumeMovement(_ event: UIDynamicItem, animator: UIDynamicAnimator, completion: @escaping (UIDynamicAnimator) -> Void) {
        guard let startRect = startRect else { return }
        
        if let item = lineView {
            if gravity != nil {
                gravity?.removeItem(item)
            }
     
            item.alpha = 0
           
            createRandomNumber { [weak self] in
                item.frame = CGRect(x: startRect.midX, y: startRect.midY, width: startRect.width, height: startRect.height)
                item.alpha = 1
                if self?.gravity == nil {
                    self?.gravity = self?.addGravityForItem(item)
                    animator.addBehavior(self!.gravity!)
                } else {
                    animator.updateItem(usingCurrentState: item)
                    self?.gravity?.addItem(item)
                }
         
                self?.lineView?.isUserInteractionEnabled = true
                completion(animator)
            }
        } else {
            completion(animator)
        }
    }
}
