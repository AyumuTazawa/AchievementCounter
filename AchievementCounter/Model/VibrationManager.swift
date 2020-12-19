//
//  VibrationManager.swift
//  AchievementCounter
//
//  Created by 田澤歩 on 2020/12/19.
//  Copyright © 2020 net.ayumutazawa. All rights reserved.
//

import Foundation
import UIKit
import AudioToolbox

class VibrationManager {
    
    var configuerViewController = ConfigurViewController()
    
    func fostVibrationCoufigur() {
        self.configuerViewController.fetchVivrationValue = UserDefaults.standard.bool(forKey: "Vibration")
        if self.configuerViewController.fetchVivrationValue == true {
            AudioServicesDisposeSystemSoundID(1003)
        } else if self.configuerViewController.fetchVivrationValue == false {
            print("振動しない")
        }
    }
}
