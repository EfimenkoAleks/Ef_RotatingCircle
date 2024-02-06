//
//  LineView.swift
//  Ef_RotatingCircle
//
//  Created by Aleksandr on 02.02.2024.
//

import UIKit

class LineView: UIView {
    
    var lineV: UIView?
    
    private var timer: Timer = Timer()
    private let lineFrame = UIScreen.main.bounds
    private let widthView: CGFloat = 100
    
    init(startY: CGFloat) {
        let frame = CGRect(x: 350, y: startY, width: widthView, height: 10)
        super.init(frame: frame)
        
        createView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createView() {
        
        backgroundColor = .green
        
        lineV = UIView()
        lineV?.backgroundColor = .blue
        lineV?.translatesAutoresizingMaskIntoConstraints = false
        
        guard let lineV = lineV else { return }
        
        addSubview(lineV)
        NSLayoutConstraint.activate([
            lineV.leadingAnchor.constraint(equalTo: leadingAnchor),
            lineV.trailingAnchor.constraint(equalTo: trailingAnchor),
            lineV.topAnchor.constraint(equalTo: topAnchor),
            lineV.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
