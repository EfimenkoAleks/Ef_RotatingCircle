//
//  CircleViewController.swift
//  Ef_RotatingCircle
//
//  Created by Aleksandr on 01.02.2024.
//

import UIKit

class CircleViewController: SM_BaseViewController {
    
    enum RoundScale {
        case plus, minus
    }
    
    //MARK: - properties
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var plusButton: RoundedButton!
    @IBOutlet private weak var minusButton: RoundedButton!
    
    private var roundView: RoundView?
    private let lineAnimator: LineAnimator = LineAnimator()
    private let lineAnimator2: LineAnimator = LineAnimator()
    private var colisionCount: Int = 0
    private var roundWidth: CGFloat = 100.0
    private let startRoundWidth: CGFloat = 100.0
    private let helper: CircleHelper = CircleHelper()
    
    lazy var behaviorRound: UIDynamicItemBehavior = { [unowned self] in
        let amin = UIDynamicItemBehavior()
        return amin
    }()
    
    lazy var animator: UIDynamicAnimator = { [unowned self] in
        let anim = UIDynamicAnimator(referenceView: self.view)
        return anim
    }()
    
    lazy var collision: UICollisionBehavior = { [unowned self] in
        let cl = UICollisionBehavior()
        cl.collisionDelegate = self
        return cl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    //MARK: - actions
    @IBAction private func didTabPlusButton(_ sender: UIButton) {
        setScaleRound(.plus)
    }
    
    @IBAction private func didTapMinusButton(_ sender: UIButton) {
        setScaleRound(.minus)
    }
    
    override func sm_didTapRightNavButton() {
        colisionCount = 0
        restartRound()
    }
}

private extension CircleViewController {
    //MARK: - SetupUI
    func setup() {
        view.backgroundColor = .white
        createRightNavBarItemWithText(title: "Restart Score", hightFont: 17)
        addRoundView()
        addLineView()
  
            guard let item1 = self.lineAnimator.lineView,
                  let item2 = self.lineAnimator2.lineView else { return }
            self.addBehaviour()
            
            self.lineAnimator.resumeMovement(item1, animator: self.animator) { [weak self] newAnimator in
                self?.animator = newAnimator
            }
            
            self.lineAnimator2.resumeMovement(item2, animator: self.animator) { [weak self] newAnimator in
                self?.animator = newAnimator
            }
    }
    
    func setScaleRound(_ scale: RoundScale) {
        switch scale {
        case .plus:
            roundWidth += 20
        case .minus:
            roundWidth -= 20
        }
        removeBehaviorFromRound()
        roundView!.frame = CGRect(x: view.bounds.size.width / 2 - (self.roundWidth / 2), y: view.bounds.size.height / 2 - (self.roundWidth / 2), width: self.roundWidth, height: self.roundWidth)
        animator.updateItem(usingCurrentState: roundView!)
        addBehaviorToRound()
    }
   
    func addBehaviour() {
        guard let roundView = roundView,
              let line1 = lineAnimator.lineView,
              let line2 = lineAnimator2.lineView else { return }
        
        let behavior = helper.addDynamicBehaviorForItem([line1, line2])
        animator.addBehavior(behavior)
        behaviorRound = helper.addDynamicBehaviorForRound([roundView])
        animator.addBehavior(behaviorRound)
        
        collision.addItem(roundView)
        collision.addItem(line1)
        collision.addItem(line2)
        
        collision.action = { [unowned self] in
            guard let roundView = self.roundView else { return }
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            roundView.transform = CGAffineTransform(rotationAngle: CGFloat.pi * 0.999 * 2)
            CATransaction.commit()
        }
        
        // add boundaries for lines
        collision.addBoundary(withIdentifier: "boundary_side_left".nsCopying, from: view.bounds.origin, to: view.bounds.botLeft)
        animator.addBehavior(collision)
    }
    
    func collisionWithItems(_ event: UIDynamicItem) {
        containerView.isUserInteractionEnabled = false
        
        if let item = lineAnimator.lineView, event === item {
            self.lineAnimator.resumeMovement(item, animator: animator) { [weak self] newAnimator in
                self?.animator = newAnimator
            }
        } else if  let item = lineAnimator2.lineView, event === item {
            self.lineAnimator2.resumeMovement(item, animator: animator) { [weak self] newAnimator in
                self?.animator = newAnimator
            }
        }
        containerView.isUserInteractionEnabled = true
    }
    
    func addRoundView() {
        roundView = RoundView(frame: CGRect(x: view.bounds.size.width / 2 - (self.roundWidth / 2), y: view.bounds.size.height / 2 - (self.roundWidth / 2), width: self.roundWidth, height: self.roundWidth))
        guard let roundView = roundView else { return }
        view.addSubview(roundView)
        
        helper.rotationRoundV(roundedView: roundView)
    }
    
    func addLineView() {
        let frame = UIScreen.main.bounds
        lineAnimator.lineView = LineView(startY: (frame.height / 2 - 62))
        lineAnimator2.lineView = LineView(startY: (frame.height / 2 + 52))
        guard let lineView1 = lineAnimator.lineView,
              let lineView2 = lineAnimator2.lineView else { return }
        view.addSubview(lineView1)
        view.addSubview(lineView2)
        lineAnimator.startRect = CGRect(x: frame.width, y: (frame.height / 2 - 62), width: 100, height: 10)
        lineAnimator2.startRect = CGRect(x: frame.width, y: (frame.height / 2 + 52), width: 100, height: 10)
    }
    
    func vibrationOn() {
        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
    }
    
    func removeBehaviorFromRound() {
        guard let roundView = roundView else { return }
        collision.removeItem(roundView)
        animator.removeBehavior(collision)
        animator.removeBehavior(behaviorRound)
    }
    
    func addBehaviorToRound() {
        guard let roundView = roundView else { return }
        behaviorRound = helper.addDynamicBehaviorForRound([roundView])
        collision.addItem(roundView)
        animator.addBehavior(behaviorRound)
        animator.addBehavior(collision)
    }
    
    func restartRound() {
        guard let roundView = roundView else { return }
        removeBehaviorFromRound()
        
        let startRect = CGRect(x: view.center.x - startRoundWidth / 2, y: view.center.y - startRoundWidth / 2, width: startRoundWidth, height: startRoundWidth)
        roundWidth = startRoundWidth
        roundView.frame = startRect
        animator.updateItem(usingCurrentState: roundView)
        
        addBehaviorToRound()
    }
}

//MARK: - Delegate
extension CircleViewController: UICollisionBehaviorDelegate {
    
    func collisionBehavior(_ behavior: UICollisionBehavior, beganContactFor item1: UIDynamicItem, with item2: UIDynamicItem, at p: CGPoint) {
        print(p)
        
        if item1.isKind(of: RoundView.self) || item2.isKind(of: RoundView.self) {
            vibrationOn()
            colisionCount += 1
            if colisionCount == 5 {
                presentAlert(title: "Game over")
            }
        }
        
        [item1, item2].forEach { event in
            if event.isKind(of: LineView.self) {
                collisionWithItems(event)
            }
        }
    }
    
    func collisionBehavior(_ behavior: UICollisionBehavior, beganContactFor item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?, at p: CGPoint) {
        print(p)
        
        collisionWithItems(item)
    }
}
