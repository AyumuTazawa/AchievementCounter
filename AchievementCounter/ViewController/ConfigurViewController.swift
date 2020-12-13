//
//  ConfigurViewController.swift
//  AchievementCounter
//
//  Created by 田澤歩 on 2020/12/11.
//  Copyright © 2020 net.ayumutazawa. All rights reserved.
//

import UIKit
import Eureka
import AudioToolbox

class ConfigurViewController: FormViewController {
  
    var onWiFi : Bool = false
    
    var valueToSave: Bool = false
    var saveVibrationValue: Bool = false
    var fetchVivrationValue: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //効果音
        form +++ Section("効果音")
            <<< SwitchRow(){ row in
                row.title = "効果音"
               let vibrationValue = UserDefaults.standard.bool(forKey: "Sound")
                row.value = vibrationValue
            }.onChange{[unowned self] row in
                self.valueToSave = row.value!
                UserDefaults.standard.set(self.valueToSave, forKey: "Sound")
        }
        //バイブレーション
        form +++ Section("バイブレーション")
            <<< SwitchRow(){ row in
                row.title = "バイブレーション"
                self.fetchVivrationValue = UserDefaults.standard.bool(forKey: "Vibration")
                row.value = self.fetchVivrationValue
            }.onChange{[unowned self] row in
                self.saveVibrationValue = row.value!
                print(self.saveVibrationValue)
                UserDefaults.standard.set(self.saveVibrationValue, forKey: "Vibration")
        }
        
        //効果音
        form +++ Section("効果音")
            <<< SwitchRow(){ row in
                row.title = "効果音"
                row.value = true
            }.onChange{[unowned self] row in
                self.onWiFi = row.value!
                print(self.onWiFi)
        }
    
    }
    
    //サウンド設定
    func fostSoundCoufigur() {
        let soundValue = UserDefaults.standard.bool(forKey: "Sound")
        if soundValue == false {
            print("サウンドなし")
        } else if soundValue == true {
            var soundIdRing:SystemSoundID = 1016
            if let soundUrl = CFBundleCopyResourceURL(CFBundleGetMainBundle(), nil, nil, nil){
                AudioServicesCreateSystemSoundID(soundUrl, &soundIdRing)
                AudioServicesPlaySystemSound(soundIdRing)
            }
        }
    }
    
    //バイブレーション設定
    func fostVibrationCoufigur() {
        self.fetchVivrationValue = UserDefaults.standard.bool(forKey: "Vibration")
        if fetchVivrationValue == true {
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.warning)
        } else if fetchVivrationValue == false {
            print("振動しない")
        }
    }
    
}
