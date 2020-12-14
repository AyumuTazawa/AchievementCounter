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
            <<< PushRow<String>() { row in
                row.title = "効果音"
                row.selectorTitle = "効果音を選択して下さい"
                row.options = ["なし", "ファンファーレ", "スクリーンロック音", "short", "double"]
                let fetchSoundId = UserDefaults.standard.string(forKey: "SoundID")
                let data = fetchSoundId
                if data == nil {
                    row.value = "なし"
                } else {
                    row.value = data
                }
            }.onChange {[unowned self] row in
                if let valu = row.value {
                    UserDefaults.standard.set(valu, forKey: "SoundID")
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
    
    //効果音
    func fostSoundCoufigur() {
        let fetchSoundId = UserDefaults.standard.string(forKey: "SoundID")
        let data = fetchSoundId
        switch data {
        case "ファンファーレ":
            var soundIdRing: SystemSoundID = 1325
            if let soundUrl = CFBundleCopyResourceURL(CFBundleGetMainBundle(), nil, nil, nil){
                AudioServicesCreateSystemSoundID(soundUrl, &soundIdRing)
                AudioServicesPlaySystemSound(soundIdRing)
            }
        case "スクリーンロック音":
            var soundIdRing: SystemSoundID = 1305
            if let soundUrl = CFBundleCopyResourceURL(CFBundleGetMainBundle(), nil, nil, nil){
                AudioServicesCreateSystemSoundID(soundUrl, &soundIdRing)
                AudioServicesPlaySystemSound(soundIdRing)
            }
        case "short":
            var soundIdRing: SystemSoundID = 1258
            if let soundUrl = CFBundleCopyResourceURL(CFBundleGetMainBundle(), nil, nil, nil){
                AudioServicesCreateSystemSoundID(soundUrl, &soundIdRing)
                AudioServicesPlaySystemSound(soundIdRing)
            }
        case "double":
            var soundIdRing: SystemSoundID = 1255
            if let soundUrl = CFBundleCopyResourceURL(CFBundleGetMainBundle(), nil, nil, nil){
                AudioServicesCreateSystemSoundID(soundUrl, &soundIdRing)
                AudioServicesPlaySystemSound(soundIdRing)
            }
        default:
            break
        }
    }
    
}
