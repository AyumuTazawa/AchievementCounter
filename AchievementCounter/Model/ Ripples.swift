//
//   Ripples.swift
//  AchievementCounter
//
//  Created by 田澤歩 on 2020/12/21.
//  Copyright © 2020 net.ayumutazawa. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func ripples(touch: UITapGestureRecognizer) {
        
        let location = touch.location(in: self)
        let layer = CAShapeLayer.init()
        self.layer.addSublayer(layer)
        layer.frame = CGRect.init(x: location.x, y: location.y, width: 100, height: 100)
        layer.position = CGPoint.init(x: location.x, y: location.y)
        layer.contents = {
            let size: CGFloat = 200.0
            UIGraphicsBeginImageContext(CGSize.init(width: size, height: size))
            let context = UIGraphicsGetCurrentContext()!
            context.saveGState()
            context.setFillColor(UIColor.clear.cgColor)
            context.fill(self.frame)
            let r = CGFloat.init(size/2-10)
            let center = CGPoint.init(x: size/2, y: size/2)
            let path : CGMutablePath = CGMutablePath()
            path.addArc(center: center, radius: r, startAngle: 0, endAngle: CGFloat(Double.pi*2), clockwise: false)
            context.addPath(path)
            context.setFillColor(UIColor.lightGray.cgColor)
            context.setStrokeColor(UIColor.lightGray.cgColor)
            context.drawPath(using: .fillStroke)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            context.restoreGState()
            return image!.cgImage
        }()
        
        let animationGroup: CAAnimationGroup = {
            let animation: CABasicAnimation = {
                let animation = CABasicAnimation(keyPath: "transform.scale")
                animation.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeOut)
                animation.duration = 0.5
                animation.isRemovedOnCompletion = false
                animation.fillMode = CAMediaTimingFillMode.forwards
                animation.fromValue = NSNumber(value: 0.5)
                animation.toValue = NSNumber(value: 5.0)
                return animation
            }()
            
            let animation2: CABasicAnimation = {
                let animation = CABasicAnimation(keyPath: "opacity")
                animation.duration = 0.5
                animation.isRemovedOnCompletion = false
                animation.fillMode = CAMediaTimingFillMode.forwards
                animation.fromValue = NSNumber(value: 0.5)
                animation.toValue = NSNumber(value: 0.0)
                return animation
            }()
            
            let group = CAAnimationGroup()
            group.beginTime = CACurrentMediaTime()
            group.animations = [animation, animation2]
            group.isRemovedOnCompletion = false
            group.fillMode = CAMediaTimingFillMode.backwards
            return group
        }()
        
        CATransaction.setAnimationDuration(5.0)
        CATransaction.setCompletionBlock({
            layer.removeFromSuperlayer()
        })
        CATransaction.begin()
        layer.add(animationGroup, forKey: nil)
        layer.opacity = 0.0
        CATransaction.commit()
    }
}
