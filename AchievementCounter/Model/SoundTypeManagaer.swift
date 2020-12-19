//
//  SoundTypeManagaer.swift
//  AchievementCounter
//
//  Created by 田澤歩 on 2020/12/19.
//  Copyright © 2020 net.ayumutazawa. All rights reserved.
//

import Foundation
import UIKit
import AudioToolbox

class SoundTypeManagaer {
    
    func setSoundTyoe(selectSoundId: SystemSoundID) {
        var soundIdRing: SystemSoundID = selectSoundId
        if let soundUrl = CFBundleCopyResourceURL(CFBundleGetMainBundle(), nil, nil, nil){
            AudioServicesCreateSystemSoundID(soundUrl, &soundIdRing)
            AudioServicesPlaySystemSound(soundIdRing)
        }
    }
}
