//
//  ImageCompression.swift
//  AchievementCounter
//
//  Created by 田澤歩 on 2020/12/17.
//  Copyright © 2020 net.ayumutazawa. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    func resized(toWidth width: CGFloat, toheight height: CGFloat) -> UIImage? {
            //let canvasSize = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
            let canvasSize = CGSize(width: CGFloat(ceil(width/size.width * size.height)), height: height)
            UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
            defer { UIGraphicsEndImageContext() }
            draw(in: CGRect(origin: .zero, size: canvasSize))
            return UIGraphicsGetImageFromCurrentImageContext()
        }
}
