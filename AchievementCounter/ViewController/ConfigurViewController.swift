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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //バイブレーション
        form +++ Section("バイブレーション")
            <<< SwitchRow(){ row in
                row.title = "バイブレーション"
               let vibrationValue = UserDefaults.standard.bool(forKey: "vibration")
                row.value = vibrationValue
            }.onChange{[unowned self] row in
                self.valueToSave = row.value!
                UserDefaults.standard.set(self.valueToSave, forKey: "vibration")
        }
        //プッシュ通知
        form +++ Section("プッシュ通知")
            <<< SwitchRow(){ row in
                row.title = "プッシュ通知"
                row.value = true
            }.onChange{[unowned self] row in
                self.onWiFi = row.value!
                print(self.onWiFi)
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
    
    //バイブレーション
    func fostVibrate() {
        let vibrationValue = UserDefaults.standard.bool(forKey: "vibration")
        if vibrationValue == false {
            print("サウンドなし")
        } else if vibrationValue == true {
            var soundIdRing:SystemSoundID = 1016
            if let soundUrl = CFBundleCopyResourceURL(CFBundleGetMainBundle(), nil, nil, nil){
                AudioServicesCreateSystemSoundID(soundUrl, &soundIdRing)
                AudioServicesPlaySystemSound(soundIdRing)
            }
        }
    }
    
    
    
}
