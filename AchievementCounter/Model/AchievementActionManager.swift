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
import PromiseKit

protocol AchievementActionManagerDelegate: class {
    func startAchievementAnimation()
    func stopAchievementAnimation()
    func removeAchievementAnimationView()
}

class AchievementActionManager {
    
    weak var delgate: AchievementActionManagerDelegate?
    var pushManager = PushManager()
    
    func achievementAction(countNumber: Int, targetNumber: Int) -> Promise<Void> {
        return Promise { resolver in
            switch countNumber {
            case targetNumber:
                //アニメーションをスタート
                self.delgate?.startAchievementAnimation()
                self.pushManager.pushConfigur()
                DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                    //アニメーションを止める
                    self.delgate?.stopAchievementAnimation()
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 8) {
                    self.delgate?.removeAchievementAnimationView()
                }
            default:
                break
            }
            resolver.fulfill(())
        }
    }
    
}
