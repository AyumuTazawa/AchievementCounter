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

    var selectSoundId: SystemSoundID!
    var saveVibrationValue: Bool = false
    var fetchVivrationValue: Bool!
    var savepushValue: Bool = false
    var fetchPuhValue: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //バイブレーション
        form +++ Section("設定")
            <<< SwitchRow(){ row in
                row.title = "バイブレーション"
                self.fetchVivrationValue = UserDefaults.standard.bool(forKey: "Vibration")
                row.value = self.fetchVivrationValue
               // print(self.fetchPuhValue)
            }.onChange{[unowned self] row in
                self.saveVibrationValue = row.value!
                UserDefaults.standard.set(self.saveVibrationValue, forKey: "Vibration")
            }
        
        //プッシュ通知
        form +++ Section()
            <<< SwitchRow(){ row in
                row.title = "目標達成通知"
                self.fetchPuhValue = UserDefaults.standard.bool(forKey: "Push")
                print(self.fetchPuhValue)
                row.value = self.fetchPuhValue
            }.onChange{[unowned self] row in
                self.savepushValue = row.value!
                UserDefaults.standard.set(self.savepushValue, forKey: "Push")
            }
        
        //効果音
        form +++ Section()
            <<< PushRow<String>() { row in
                row.title = "効果音"
                row.selectorTitle = "効果音を選択して下さい"
                row.options = ["なし", "ファンファーレ", "スクリーンロック音", "short", "double"]
                let fetchSoundId = UserDefaults.standard.string(forKey: "SoundID")
                if fetchSoundId == nil {
                    row.value = "なし"
                } else {
                    row.value = fetchSoundId
                }
            }.onChange {[unowned self] row in
                if let valu = row.value {
                    UserDefaults.standard.set(valu, forKey: "SoundID")
                }
            }
    }
    
    //プッシュ通知設置
    func pushConfigur() {
        print("aaaa")
       self.fetchPuhValue = UserDefaults.standard.bool(forKey: "Push")
        if self.fetchPuhValue == true {
            print("aa")
            let content = UNMutableNotificationContent()
            content.title = "目標達成！！"
            content.body = "どんどん頑張ろう！"
            content.sound = UNNotificationSound.default
            let request = UNNotificationRequest(identifier: "immediately", content: content, trigger: nil)
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        } else if self.fetchPuhValue == false {
            print("何もしない")

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
            self.selectSoundId = 1325
            self.soundTyoe(selectSoundId: self.selectSoundId)
        case "スクリーンロック音":
            self.selectSoundId = 1305
            self.soundTyoe(selectSoundId: self.selectSoundId)
        case "short":
            self.selectSoundId = 1258
            self.soundTyoe(selectSoundId: self.selectSoundId)
        case "double":
            self.selectSoundId = 1255
            self.soundTyoe(selectSoundId: self.selectSoundId)
        default:
            break
        }
    }
    
    func soundTyoe(selectSoundId: SystemSoundID) {
        var soundIdRing: SystemSoundID = selectSoundId
        if let soundUrl = CFBundleCopyResourceURL(CFBundleGetMainBundle(), nil, nil, nil){
            AudioServicesCreateSystemSoundID(soundUrl, &soundIdRing)
            AudioServicesPlaySystemSound(soundIdRing)
        }
    }
    
}
