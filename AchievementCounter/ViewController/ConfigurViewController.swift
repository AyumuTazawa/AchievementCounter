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
import CropViewController

protocol ConfigurViewControlleDelegate: class {
    func setBackgroundColor()
}

class ConfigurViewController: FormViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CropViewControllerDelegate {
    
    weak var delgate: ConfigurViewControlleDelegate?
    var countViewController: CountViewController!
    var selectSoundId: SystemSoundID!
    var saveVibrationValue: Bool = false
    var fetchVivrationValue: Bool!
    var savepushValue: Bool = false
    var fetchPuhValue: Bool!
    var colorData: String!
    var selectColorName: String!
    var selectImage: NSData!
    // var image:UIImage?
    var soundTypeManagaer = SoundTypeManagaer()
    var fetcImagewidth: Double!
    var fetcImageheight: Double!
    var fetchripplesValue: Bool!
    var fetchTheme: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.countViewController = CountViewController()
        self.fetcImagewidth = UserDefaults.standard.double(forKey: "Imagewidth")
        self.fetcImageheight = UserDefaults.standard.double(forKey: "Imageheight")
        //テーマ
        form +++ Section("テーマ")
            <<< TextRow(){ row in
                row.title = "取り組むこと"
                row.placeholder = "(例)腕立て10回3セット"
                fetchTheme = UserDefaults.standard.string(forKey: "Theme")
                row.value = fetchTheme
                
            }.onChange{ row in
                var saveTheme:String!
                saveTheme = row.value
                UserDefaults.standard.set(saveTheme, forKey: "Theme")
                }
        form +++ Section("設定")
            //波紋
            <<< SwitchRow(){ row in
                self.fetchripplesValue = UserDefaults.standard.bool(forKey: "Ripples")
                row.value = self.fetchripplesValue
                row.title = "タップアニメーション"
            }.onChange{[unowned self] row in
                let saveRipplesValue = row.value!
                UserDefaults.standard.set(saveRipplesValue, forKey: "Ripples")
            }
            //バイブレーション
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
            
            <<< PushRow<String>() { row in
                row.title = "テキストカラー"
                row.selectorTitle = "テキストカラーを選択して下さい"
                row.options = ["しろ", "くろ", "あお", "あか"]
                let fetchTextColor = UserDefaults.standard.string(forKey: "TextColor")
                if fetchTextColor == nil {
                    row.value = "ホワイト"
                } else {
                    row.value = fetchTextColor
                }
            }.onChange {[unowned self] row in
                if let valu = row.value {
                    UserDefaults.standard.set(valu, forKey: "TextColor")
                }
            }.onPresent { form, selectorController in
                selectorController.enableDeselection = false
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
            }.onPresent { form, selectorController in
                selectorController.enableDeselection = false
            }
            //背景色
            <<< PushRow<String>() { row in
                row.title = "背景"
                row.selectorTitle = "背景を選択して下さい"
                row.options = ["みどり", "あお", "ぴんく", "むらさき", "画像"]
                let fetchColorName = UserDefaults.standard.string(forKey: "ColorName")
                if fetchColorName == nil {
                    row.value = "みどり"
                } else if fetchColorName == "画像" {
                    row.value = nil
                } else {
                    row.value = fetchColorName
                }
            }.onChange {[unowned self] row  in
                if let valu = row.value {
                    print(valu)
                    if valu == "画像" {
                        print("gazou")
                        self.setImagePicker()
                        UserDefaults.standard.set(valu, forKey: "ColorName")
                    } else {
                        print(valu)
                        UserDefaults.standard.setValue(valu, forKey: "SaveColor")
                        UserDefaults.standard.set(valu, forKey: "ColorName")
                    }
                }
            }.onPresent { form, selectorController in
                selectorController.enableDeselection = false
            }
        //紙吹雪の種類
        form +++ Section("紙吹雪の設定")
            <<< PushRow<String>() { row in
                row.title = "紙吹雪の種類"
                row.selectorTitle = "紙吹雪の種類を選択して下さい"
                row.options = ["紙吹雪", "さんかく", "ひしがた", "ほし"]
                let fetchanimationType = UserDefaults.standard.string(forKey: "animationType")
                if fetchanimationType == nil {
                    row.value = "紙吹雪"
                } else {
                    row.value = fetchanimationType
                }
            }.onChange {[unowned self] row in
                if let valu = row.value {
                    print(valu)
                    UserDefaults.standard.set(valu, forKey: "animationType")
                }
            }.onPresent { form, selectorController in
                selectorController.enableDeselection = false
            }
            //紙吹雪の量
            <<< PushRow<String>() { row in
                row.title = "紙吹雪の量"
                row.selectorTitle = "紙吹雪の量を選択して下さい"
                row.options = ["レベル1", "レベル2", "レベル3", "レベル4"]
                let fetchConfettiAmount = UserDefaults.standard.string(forKey: "ConfettiAmount")
                if fetchConfettiAmount == nil {
                    row.value = "レベル3"
                } else {
                    row.value = fetchConfettiAmount
                }
            }.onChange {[unowned self] row in
                if let valu = row.value {
                    UserDefaults.standard.set(valu, forKey: "ConfettiAmount")
                }
            }.onPresent { form, selectorController in
                selectorController.enableDeselection = false
            }
        
        //Progressbarの設定
        form +++ Section("プログレスバーの設定")
            <<< PushRow<String>() { row in
                row.title = "プログレスカラー"
                row.selectorTitle = "プログレスバーの色を選択して下さい"
                row.options = ["しろ", "くろ", "あお", "みどり", "あか"]
                //ユーザーデフォルト
                let fetchProgressColor = UserDefaults.standard.string(forKey: "PrpgressColor")
                print("フェッチカラー\(fetchProgressColor)")
                if fetchProgressColor == nil {
                    row.value = "みどり"
                } else {
                    row.value = fetchProgressColor
                }
            }.onChange {[unowned self] row in
                if let valu = row.value {
                    //UserDEfaultsにProgressbarのカラーを保存
                    UserDefaults.standard.set(valu, forKey: "PrpgressColor")
                }
            }.onPresent { form, selectorController in
                selectorController.enableDeselection = false
            }
        
        //バージョン表示
        form +++ Section("情報")
            <<< LabelRow() { row in
                let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
                row.title = "バージョン"
                row.value = version
            }
    }
    
    //効果音
    func fostSoundCoufigur() {
        let fetchSoundId = UserDefaults.standard.string(forKey: "SoundID")
        let data = fetchSoundId
        switch data {
        case "タップ":
            self.selectSoundId = 1104
            self.soundTypeManagaer.setSoundTyoe(selectSoundId: self.selectSoundId)
        case "ロック":
            self.selectSoundId = 1305
            self.soundTypeManagaer.setSoundTyoe(selectSoundId: self.selectSoundId)
        case "シャッター":
            self.selectSoundId = 1108
            self.soundTypeManagaer.setSoundTyoe(selectSoundId: self.selectSoundId)
        case "プッシュ":
            self.selectSoundId = 1200
            self.soundTypeManagaer.setSoundTyoe(selectSoundId: self.selectSoundId)
        default:
            break
        }
    }
    
    //背景色設定
    func backgroundColorhConfigur() {
        let fetchColorName = UserDefaults.standard.string(forKey: "ColorName")
        UserDefaults.standard.setValue(fetchColorName, forKey: "SaveColor")
        self.colorData = fetchColorName
        print("背景設定")
        switch colorData {
        case "みどり":
            self.selectColorName = "7bdcd0"
            self.selectImage = nil
            delgate?.setBackgroundColor()
        case "あお":
            self.selectColorName = "4887BF"
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
            if fetchbackgroundImage == nil {
                setSavedBackgroundImage()
            } else {
                self.selectImage = fetchbackgroundImage as! NSData
                delgate?.setBackgroundColor()
            }
            
        default:
            self.selectColorName = "7bdcd0"
            delgate?.setBackgroundColor()
        }
    }
    
    func setImagePicker(){
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        //トリミング編集が終えたら、呼び出される。
        print("image")
        updateImageViewWithImage(image, fromCropViewController: cropViewController)
    }
    
    func updateImageViewWithImage(_ image: UIImage, fromCropViewController cropViewController: CropViewController) {
        let saveImageData = image.pngData() as NSData?
        UserDefaults.standard.set(saveImageData, forKey: "backgroundImage")
        UserDefaults.standard.synchronize()
        cropViewController.dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])  {
        guard let pickerImage = (info[UIImagePickerController.InfoKey.originalImage] as? UIImage) else { return }
        let cropController = CropViewController(croppingStyle: .default, image: pickerImage)
        
        cropController.delegate = self
        
        cropController.customAspectRatio = CGSize(width: self.fetcImagewidth, height: self.fetcImageheight)
        
        cropController.aspectRatioPickerButtonHidden = true
        cropController.resetAspectRatioEnabled = false
        cropController.rotateButtonsHidden = true
        
        cropController.cropView.cropBoxResizeEnabled = false
        
        picker.dismiss(animated: true) {
            
            self.present(cropController, animated: true, completion: nil)
        }
    }
    
    // 画像選択キャンセル
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setSavedBackgroundImage() {
        let saveColor = UserDefaults.standard.string(forKey: "SaveColor")
        switch saveColor {
        case "みどり":
            self.selectColorName = "7bdcd0"
            self.selectImage = nil
            delgate?.setBackgroundColor()
        case "あお":
            self.selectColorName = "4887BF"
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
        default:
            self.selectColorName = "7bdcd0"
            delgate?.setBackgroundColor()
        }
    }
    
}
