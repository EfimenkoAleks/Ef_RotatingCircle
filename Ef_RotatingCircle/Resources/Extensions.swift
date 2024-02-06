//
//  Extensions.swift
//  Ef_RotatingCircle
//
//  Created by Aleksandr on 05.02.2024.
//

import Foundation

extension CGRect {
    var end: CGPoint {
        return CGPoint(x: origin.x + size.width, y: origin.y + size.height)
    }
    var topRight: CGPoint {
        return CGPoint(x: origin.x + size.width, y: origin.y)
    }
    var botLeft: CGPoint {
        return CGPoint(x: origin.x, y: origin.y + size.height)
    }
}

extension CGPoint {
    func offsetBy(x x_: CGFloat, y y_: CGFloat) -> CGPoint {
        return CGPoint(x: x + x_, y: y + y_)
    }
}

extension NSCopying {
    var string: String {
        return self as! String
    }
}

extension String {
    var nsCopying: NSCopying {
        return self as NSCopying
    }
}
