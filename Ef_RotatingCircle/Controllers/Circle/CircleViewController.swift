//
//  CircleViewController.swift
//  Ef_RotatingCircle
//
//  Created by Aleksandr on 01.02.2024.
//

import UIKit

class CircleViewController: UIViewController {
    
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var buttonsStack: UIStackView!
    @IBOutlet private weak var plusButton: UIButton!
    @IBOutlet private weak var minusButton: UIButton!
    
    private var roundView: RoundView?
    private let lineAnimator: LineAnimator = LineAnimator()
    private let lineAnimator2: LineAnimator = LineAnimator()
    private var colisionCount: Int = 0
    private let frame = UIScreen.main.bounds
    private var roundWidth: CGFloat = 100.0
    
    lazy var animator: UIDynamicAnimator = { [unowned self] in
        let amin = UIDynamicAnimator(referenceView: self.view)
        return amin
    }()
    
    lazy var collision: UICollisionBehavior = { [unowned self] in
        let cl = UICollisionBehavior()
        //   cl.translatesReferenceBoundsIntoBoundary = true
        cl.collisionDelegate = self
        return cl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    //MARK: - didTabPlusButton
    @IBAction private func didTabPlusButton(_ sender: UIButton) {
        roundWidth += 20
        let point = CGPoint(x: view.center.x - roundView!.frame.width / 2, y: view.center.y - roundView!.frame.height / 2)
        roundView!.frame = CGRect(origin: point, size: CGSize(width: roundWidth, height: roundWidth))
        animator.updateItem(usingCurrentState: roundView!)
    }
    
    @IBAction private func didTapMinusButton(_ sender: UIButton) {
        roundWidth -= 20
        let point = CGPoint(x: view.center.x - roundView!.frame.width / 2, y: view.center.y - roundView!.frame.height / 2)
        roundView!.frame = CGRect(origin: point, size: CGSize(width: roundWidth, height: roundWidth))
        animator.updateItem(usingCurrentState: roundView!)
    }
}

private extension CircleViewController {
    //MARK: - SetupUI
    func setup() {
        view.backgroundColor = .white
        createRightNavBarItemWithText(title: "Restart", hightFont: 17)
        addRoundView()
        addLineView()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let self = self,
                  let item1 = self.lineAnimator.lineView,
                  let item2 = self.lineAnimator2.lineView else { return }
            self.addCollisionBehaviour()
            
            self.lineAnimator.resumeMovement(item1, animator: self.animator) { [weak self] newAnimator in
                self?.animator = newAnimator
            }
            
            self.lineAnimator2.resumeMovement(item2, animator: self.animator) { [weak self] newAnimator in
                self?.animator = newAnimator
            }
        }
        
    }
    
    func addDynamicBehaviorForItem(_ items: [UIView]) -> UIDynamicItemBehavior {
        let behavior = UIDynamicItemBehavior(items: items)
        behavior.resistance = 0
        behavior.angularResistance = 0
        behavior.allowsRotation = false
        //     behavior.isAnchored = true
        
        return behavior
    }
    
    func addDynamicBehaviorForRound(_ items: [UIView]) -> UIDynamicItemBehavior {
        let behavior = UIDynamicItemBehavior(items: items)
        behavior.resistance = 0
        behavior.density = 1
        behavior.angularResistance = 0
        behavior.allowsRotation = true
        behavior.isAnchored = true
        
        return behavior
    }
    
    func addCollisionBehaviour() {
        guard let roundView = roundView,
              let line1 = lineAnimator.lineView,
              let line2 = lineAnimator2.lineView else { return }
        
        collision.addItem(roundView)
        collision.addItem(line1)
        collision.addItem(line2)
        
        let behavior = addDynamicBehaviorForItem([line1, line2])
        animator.addBehavior(behavior)
        let behaviorRound = addDynamicBehaviorForRound([roundView])
        animator.addBehavior(behaviorRound)
        
        //        // add boundaries for lines
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
        roundView = RoundView(frame: CGRect(x: view.center.x - roundWidth / 2, y: view.center.y - roundWidth / 2, width: roundWidth, height: roundWidth))
        guard let roundView = roundView else { return }
        view.addSubview(roundView)
        
        rotationRoundV()
    }
    
    func addLineView() {
        lineAnimator.lineView = LineView(startY: (frame.height / 2 - 62))
        lineAnimator2.lineView = LineView(startY: (frame.height / 2 + 52))
        guard let lineView1 = lineAnimator.lineView,
              let lineView2 = lineAnimator2.lineView else { return }
        view.addSubview(lineView1)
        view.addSubview(lineView2)
        lineAnimator.startRect = CGRect(x: self.frame.width, y: (self.frame.height / 2 - 62), width: 100, height: 10)
        lineAnimator2.startRect = CGRect(x: self.frame.width, y: (self.frame.height / 2 + 52), width: 100, height: 10)
    }
    
    func vibrationOn() {
        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
    }
    
    func rotationRoundV() {
        
        
        UIView.animate(withDuration: 3.0, delay: 0.0, options: .curveLinear) { [weak self] in
            guard let self = self,
                  let roundView = self.roundView else { return }
            
            roundView.transform = CGAffineTransform.identity
            roundView.transform = CGAffineTransform(rotationAngle: CGFloat.pi * 0.999)
        } completion: { _ in
            UIView.animate(withDuration: 3.0, delay: 0.0, options: .curveLinear) { [weak self] in
                guard let self = self,
                      let roundView = self.roundView else { return }
                
                roundView.transform = CGAffineTransform(rotationAngle: CGFloat.pi * 0.999 * 2)
            } completion: { [weak self] _ in
                guard let self = self else { return }
                self.rotationRoundV()
            }
        }
    }
    
    func presentAlert(title: String = "", message: String = "") {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        self.present(alert, animated: true)
    }
    
    func createRightNavBarItemWithText(title: String, hightFont: CGFloat) {
        let font = UIFont.systemFont(ofSize: hightFont, weight: .medium)
        let style = UINavigationBarAppearance()
        style.buttonAppearance.normal.titleTextAttributes = [.font: font]
        navigationItem.standardAppearance = style
        let rightBarButtonItem = UIBarButtonItem.init(title: title, style: .plain, target: self, action: #selector(sm_didTapRightNavButton))
        rightBarButtonItem.tintColor = .black
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    @objc func sm_didTapRightNavButton() {
        colisionCount = 0
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
            let startRect = CGRect(x: view.center.x - 50, y: view.center.y - 50, width: 100, height: 100)
            roundView!.frame = startRect
            animator.updateItem(usingCurrentState: roundView!)
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

extension CircleViewController: UIDynamicAnimatorDelegate {
    func dynamicAnimatorDidPause(_ animator: UIDynamicAnimator) {
        print("dynamicAnimatorDidPause")
    }
    
    func dynamicAnimatorWillResume(_ animator: UIDynamicAnimator) {
        print("dynamicAnimatorWillResume")
    }
}
