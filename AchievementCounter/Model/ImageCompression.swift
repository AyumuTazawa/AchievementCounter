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
    func resized(withPercentage percentage: CGFloat) -> UIImage? {
            let canvas = CGSize(width: size.width * percentage, height: size.height * percentage)
            return UIGraphicsImageRenderer(size: canvas, format: imageRendererFormat).image {
                _ in draw(in: CGRect(origin: .zero, size: canvas))
            }
        }
}
