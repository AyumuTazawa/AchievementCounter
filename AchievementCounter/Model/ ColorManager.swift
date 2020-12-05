//
//   Color.swift
//  AchievementCounter
//
//  Created by 田澤歩 on 2020/12/05.
//  Copyright © 2020 net.ayumutazawa. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return self.init(red: red / 255, green: green / 255, blue: blue / 255, alpha: 1)
    }
}
