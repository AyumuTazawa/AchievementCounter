//
//  AchievementActionManager.swift
//  AchievementCounter
//
//  Created by 田澤歩 on 2020/12/02.
//  Copyright © 2020 net.ayumutazawa. All rights reserved.
//

import Foundation
import UIKit
import SwiftConfettiView


protocol AchievementActionManagerDelegate: class {
    func startAchievementAnimation()
    func stopAchievementAnimation()
    func removeAchievementAnimationView()
}

class AchievementActionManager {
    
    //var achievementAnimation: SwiftConfettiView!
    var countViewController = CountViewController()
    weak var delgate: AchievementActionManagerDelegate?
    
    
    func achievementAction(countNumber: Int, targetNumber: Int) {
        if countNumber == targetNumber {
            //アニメーションをスタート
            delgate?.startAchievementAnimation()
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                //アニメーションを止める
                self.delgate?.stopAchievementAnimation()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
                self.delgate?.removeAchievementAnimationView()
            }
        }
    }
}
