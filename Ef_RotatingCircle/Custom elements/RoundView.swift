//
//  RoundView.swift
//  Ef_RotatingCircle
//
//  Created by Aleksandr on 02.02.2024.
//

import UIKit

class RoundView: UIView {
    
    enum RoundScale {
        case plus, minus
    }
    
    public override var collisionBoundsType: UIDynamicItemCollisionBoundsType {
        return .ellipse
    }
    
    var roundV: UIView?
    private var valueX: Double = 1.0
    private var valueY: Double = 1.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        createView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
    }
    
    private func createView() {
        
        roundV = UIView()
        roundV?.backgroundColor = .purple
        roundV?.translatesAutoresizingMaskIntoConstraints = false
        
        guard let roundV = roundV else { return }
        
        addSubview(roundV)
        NSLayoutConstraint.activate([
            roundV.leadingAnchor.constraint(equalTo: leadingAnchor),
            roundV.trailingAnchor.constraint(equalTo: trailingAnchor),
            roundV.topAnchor.constraint(equalTo: topAnchor),
            roundV.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        layer.masksToBounds = true
        
        let line = UIView()
        line.backgroundColor = .red
        line.translatesAutoresizingMaskIntoConstraints = false
        
        roundV.addSubview(line)
        NSLayoutConstraint.activate([
            line.leadingAnchor.constraint(equalTo: roundV.leadingAnchor, constant: 10),
            line.trailingAnchor.constraint(equalTo: roundV.trailingAnchor, constant: -10),
            line.centerYAnchor.constraint(equalTo: roundV.centerYAnchor),
            line.heightAnchor.constraint(equalToConstant: 10)
        ])
    }
    
    func setScale(_ event: RoundScale, completion: @escaping (CGRect) -> Void) {
        switch event {
        case .plus:
            valueX += 0.1
            valueY += 0.1
        case .minus:
            valueX -= 0.1
            valueY -= 0.1
        }
        
        scaleView(newX: valueX, newY: valueY) {
            completion(self.bounds)
        }
    }
    
    private func scaleView(newX: Double, newY: Double, completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0.0,
                       animations: { [weak self] in
            guard let self = self else { return }
            self.roundV?.transform = CGAffineTransform(scaleX: newX, y: newY)
        },
                       completion: { _ in
            completion()
        })
    }
    
    func setStartValue(completion: @escaping () -> Void) {
        valueX = 1.0
        valueY = 1.0
        scaleView(newX: valueX, newY: valueY) {
            completion()
        }
    }
}
