//
//  RoundedButton.swift
//  Ef_RotatingCircle
//
//  Created by Aleksandr on 07.02.2024.
//

import UIKit

 class RoundedButton: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = frame.height / 2
        layer.masksToBounds = true
    }
}
