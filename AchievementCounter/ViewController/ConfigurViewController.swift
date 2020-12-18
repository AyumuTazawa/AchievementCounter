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

protocol ConfigurViewControlleDelegate: class {
    func setBackgroundColor()
}

class ConfigurViewController: FormViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    weak var delgate: ConfigurViewControlleDelegate?
    
    var selectSoundId: SystemSoundID!
    var saveVibrationValue: Bool = false
    var fetchVivrationValue: Bool!
    var savepushValue: Bool = false
    var fetchPuhValue: Bool!
    var colorData: String!
    var selectColorName: String!
    var selectImage: NSData!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //バイブレーション
        form +++ Section("設定")
            <<< SwitchRow(){ row in
                row.title = "バイブレーション"
                self.fetchVivrationValue = UserDefaults.standard.bool(forKey: "Vibration")
                row.value = self.fetchVivrationValue
            }.onChange{[unowned self] row in
                self.saveVibrationValue = row.value!
                UserDefaults.standard.set(self.saveVibrationValue, forKey: "Vibration")
            }
            
            //プッシュ通知
            <<< SwitchRow(){ row in
                row.title = "目標達成通知"
                self.fetchPuhValue = UserDefaults.standard.bool(forKey: "Push")
                row.value = self.fetchPuhValue
            }.onChange{[unowned self] row in
                self.savepushValue = row.value!
                UserDefaults.standard.set(self.savepushValue, forKey: "Push")
            }
            
            //効果音
            <<< PushRow<String>() { row in
                row.title = "効果音"
                row.selectorTitle = "効果音を選択して下さい"
                row.options = ["なし", "タップ", "ロック", "シャッター", "プッシュ"]
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
            //背景色
            <<< PushRow<String>() { row in
                row.title = "背景"
                row.selectorTitle = "背景を選択して下さい"
                row.options = ["みどり", "あお", "みずいろ", "ぴんく", "むらさき", "画像"]
                let fetchColorName = UserDefaults.standard.string(forKey: "ColorName")
                if fetchColorName == nil {
                    row.value = "みどり"
                } else {
                    print(fetchColorName)
                    row.value = fetchColorName
                }
                print(row.value)
            }.onChange {[unowned self] row in
                if let valu = row.value {
                    print(valu)
                    if valu == "画像" {
                        print("gazou")
                        let picker = UIImagePickerController()
                        picker.sourceType = .photoLibrary
                        picker.delegate = self
                        present(picker, animated: true)
                        self.present(picker, animated: true, completion: nil)
                        UserDefaults.standard.set(valu, forKey: "ColorName")
                    } else {
                        UserDefaults.standard.set(valu, forKey: "ColorName")
                    }
                }
            }
        
        form +++ Section("情報")
            <<< LabelRow() { row in
                let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
                row.title = "バージョン"
                row.value = version
            }
    }
    
    //バイブレーション設定
    func fostVibrationCoufigur() {
        self.fetchVivrationValue = UserDefaults.standard.bool(forKey: "Vibration")
        if fetchVivrationValue == true {
            AudioServicesDisposeSystemSoundID(1003)
        } else if fetchVivrationValue == false {
            print("振動しない")
        }
    }
    
    //プッシュ通知設置
    func pushConfigur() {
        self.fetchPuhValue = UserDefaults.standard.bool(forKey: "Push")
        if self.fetchPuhValue == true {
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
    
    //効果音
    func fostSoundCoufigur() {
        let fetchSoundId = UserDefaults.standard.string(forKey: "SoundID")
        let data = fetchSoundId
        switch data {
        case "タップ":
            self.selectSoundId = 1104
            self.soundTyoe(selectSoundId: self.selectSoundId)
        case "ロック":
            self.selectSoundId = 1305
            self.soundTyoe(selectSoundId: self.selectSoundId)
        case "シャッター":
            self.selectSoundId = 1108
            self.soundTyoe(selectSoundId: self.selectSoundId)
        case "プッシュ":
            self.selectSoundId = 1200
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
    
    //背景色設定
    func backgroundColorhConfigur() {
        let fetchColorName = UserDefaults.standard.string(forKey: "ColorName")
        self.colorData = fetchColorName
        print("背景設定")
        switch colorData {
        case "みどり":
            UserDefaults.standard.removeObject(forKey: "backgroundImage")
            self.selectColorName = "7bdcd0"
            self.selectImage = nil
            delgate?.setBackgroundColor()
        case "あお":
            UserDefaults.standard.removeObject(forKey: "backgroundImage")
            self.selectColorName = "4887BF"
            self.selectImage = nil
            delgate?.setBackgroundColor()
        case "みずいろ":
            self.selectColorName = "83CCD2"
            self.selectImage = nil
            delgate?.setBackgroundColor()
        case "ぴんく":
            self.selectColorName = "EE869A"
            self.selectImage = nil
            delgate?.setBackgroundColor()
        case "むらさき":
            self.selectColorName = "a596c7"
            self.selectImage = nil
            delgate?.setBackgroundColor()
        case "画像":
            let fetchbackgroundImage = UserDefaults.standard.data(forKey: "backgroundImage")
            self.selectImage = fetchbackgroundImage as! NSData
            delgate?.setBackgroundColor()
        default:
            self.selectColorName = "7bdcd0"
            delgate?.setBackgroundColor()
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])  {
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            let resizedImage = selectedImage.resized(withPercentage: 1.0)
            let saveImageData = resizedImage!.pngData() as NSData?
            UserDefaults.standard.set(saveImageData, forKey: "backgroundImage")
            UserDefaults.standard.synchronize()
        }
        self.dismiss(animated: true)
    }
    
    // 画像選択キャンセル
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
