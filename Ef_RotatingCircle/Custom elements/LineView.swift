//
//  LineView.swift
//  Ef_RotatingCircle
//
//  Created by Aleksandr on 02.02.2024.
//

import UIKit

class LineView: UIView {
    
    var roundV: UIView?
    var startY: CGFloat
    private var timer: Timer = Timer()
    private let lineFrame = UIScreen.main.bounds
    private let widthView: CGFloat = 100
    
    init(startY: CGFloat) {
        let frame = CGRect(x: lineFrame.width, y: startY, width: widthView, height: 10)
        self.startY = startY
        super.init(frame: frame)
        
        createView()
        createRandomNumber()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createView() {
        
        roundV = UIView()
        roundV?.backgroundColor = .blue
        roundV?.translatesAutoresizingMaskIntoConstraints = false
        
        guard let roundV = roundV else { return }
        
        addSubview(roundV)
        NSLayoutConstraint.activate([
            roundV.leadingAnchor.constraint(equalTo: leadingAnchor),
            roundV.trailingAnchor.constraint(equalTo: trailingAnchor),
            roundV.topAnchor.constraint(equalTo: topAnchor),
            roundV.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func createRandomNumber() {
        let randomInt = Int.random(in: 2..<5)
        setTimer(time: Double(randomInt))
    }
    
    private func setTimer(time: Double) {
      
        timer.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: time, repeats: true) { [weak self] _ in
       
            guard let self = self,
            let roundV = self.roundV else { return }
           
            self.translationLine(animatedView: roundV, translation: (self.lineFrame.width + self.widthView), duration: time)
        }
    }
    
    private func translationLine(animatedView: UIView, translation: CGFloat, duration: Double) {
        
        UIView.animate(withDuration: duration, delay: 0.0, options: .curveEaseIn, animations: {
            animatedView.frame.origin.x += -translation
        },completion: { _ in
            animatedView.frame.origin.x += translation
        }
        )
    }
}
