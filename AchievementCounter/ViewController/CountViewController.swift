//
//  CountViewController.swift
//  AchievementCounter
//
//  Created by 田澤歩 on 2020/12/02.
//  Copyright © 2020 net.ayumutazawa. All rights reserved.
//

import UIKit
import SwiftConfettiView
import PromiseKit
import Instructions
import MBCircularProgressBar

class CountViewController: UIViewController, UIGestureRecognizerDelegate, CountNumberManagerDelegate, TargetNumberManagerDelegate, AchievementActionManagerDelegate, ConfigurViewControlleDelegate, RipplesManagaerDelegate, TextColorManagerDelegate {
    
    var touchData: UIGestureRecognizer!
    var achievementAnimation: SwiftConfettiView!
    var countNumberManager: CountNumberManager!
    var targetNumberManager: TargetNumberManager!
    var achievementActionManager: AchievementActionManager!
    var configurViewController: ConfigurViewController!
    var vibrationManager: VibrationManager!
    var ripplesManagaer: RipplesManagaer!
    var textColorManager: TextColorManager!
    var imageSize: CGSize!
    var coachController = CoachMarksController()
    var achievementPercent: Float!
    private var pointOfInterest:UIView!
    private var messages = ["画面をタップして数を数える", "マイナスボタン", "リセットボタン"]
    @IBOutlet weak var bacgroundImageView: UIImageView!
    @IBOutlet weak var countedNumberDisplayLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var progressView: MBCircularProgressBarView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        progressView.maxValue = 100
        
        self.coachController.dataSource = self
        self.pointOfInterest = self.countedNumberDisplayLabel
        self.pointOfInterest = self.minusButton
        self.pointOfInterest = self.deleteButton
        
        getImageSize()
        
        self.countNumberManager = CountNumberManager()
        self.targetNumberManager = TargetNumberManager()
        self.achievementActionManager = AchievementActionManager()
        self.configurViewController = ConfigurViewController()
        self.vibrationManager = VibrationManager()
        self.ripplesManagaer = RipplesManagaer()
        self.textColorManager = TextColorManager()
        
        countNumberManager.delgate = self
        targetNumberManager.delgate = self
        achievementActionManager.delgate = self
        configurViewController.delgate = self
        ripplesManagaer.delgate = self
        textColorManager.delegate = self
        
        let plassGestur = UITapGestureRecognizer(target: self, action: #selector(tapped(_:)))
        plassGestur.delegate = self
        self.view.addGestureRecognizer(plassGestur)
        //デリートボタン
        self.deleteButton.layer.cornerRadius = 40.0
        self.deleteButton.layer.shadowOffset = CGSize(width: 0.0, height: 1)
        self.deleteButton.layer.shadowRadius = 1.5
        self.deleteButton.layer.shadowColor = UIColor.black.cgColor
        self.deleteButton.layer.shadowOpacity = 0.7
        //マイナスボタン
        self.minusButton.layer.cornerRadius = 40.0
        self.minusButton.layer.shadowOffset = CGSize(width: 0.0, height: 1)
        self.minusButton.layer.shadowRadius = 1.5
        self.minusButton.layer.shadowColor = UIColor.black.cgColor
        self.minusButton.layer.shadowOpacity = 0.7
        
        //カウント回数を表示
        self.countNumberManager.fecthData()
        //navigationTitleセット
        self.targetNumberManager.fecthTargetNumber()
        
        self.percent()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.configurViewController.backgroundColorhConfigur()
        self.textColorManager.textColorConfigur()
    }
    
    func setProgressColor() {
        
    }
    
    func setBackgroundColor() {
        if self.configurViewController.selectColorName == nil {
            print("nanimosinai")
        } else {
            self.bacgroundImageView.image = nil
            self.view.backgroundColor = UIColor(hex: configurViewController.selectColorName)
        }
        if self.configurViewController.selectImage == nil {
            print("nanimosinai")
        } else {
            //self.view.backgroundColor = UIColor(patternImage: UIImage(data: self.configurViewController.selectImage as Data)!)
            self.bacgroundImageView.image = UIImage(data: self.configurViewController.selectImage as Data)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let userDefaults = UserDefaults.standard
        let firstStartupKey = "firstStartupKey"
        if userDefaults.bool(forKey: firstStartupKey) {
            userDefaults.set(false, forKey: firstStartupKey)
            userDefaults.synchronize()
            self.coachController.start(in: .currentWindow(of: self))
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.coachController.stop(immediately: true)
    }
    
    func getImageSize() {
        self.imageSize = self.bacgroundImageView.frame.size
        let saveImagewidth = Double(imageSize.width)
        let saveImageheight = Double(imageSize.height)
        UserDefaults.standard.set(saveImagewidth, forKey: "Imagewidth")
        UserDefaults.standard.set(saveImageheight, forKey: "Imageheight")
    }
    
    @objc func tapped(_ sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            self.touchData = sender
            self.fostAddNumber()
            //self.view.ripples(touch: sender)
            self.ripplesManagaer.ripplesConfiguer(touchData: sender)
            
        }
    }
    
    func showRipples(touchData: UITapGestureRecognizer) {
        self.view.ripples(touch: touchData)
    }
    
    func fostAddNumber() {
        let fetchSoundId = UserDefaults.standard.string(forKey: "SoundID")
        self.vibrationManager.fostVibrationCoufigur()
        self.configurViewController.fostSoundCoufigur()
        
        switch countNumberManager.fecthCountNumber {
        case 0:
            firstly {
                self.countNumberManager.deleteData()
            }.then {
                self.countNumberManager.plassNumber()
            }.then { fecthCountNumber in
                self.countNumberManager.saveData(with: fecthCountNumber)
            }.then {
                self.countNumberManager.fecthData()
            }.catch { err in
                self.showErrorAlert(title: "エラー", message: "操作をやり直してください")
            }.finally {
                self.percent()
            }
        case -1:
            firstly {
                self.countNumberManager.plassNumber()
            }.then { fecthCountNumber in
                self.countNumberManager.updataData(with: fecthCountNumber)
            }.then {
                self.countNumberManager.fecthData()
            }.then {_ in
                self.targetNumberManager.fecthTargetNumber()
            }.catch { err in
                self.showErrorAlert(title: "エラー", message: "操作をやり直してください")
            }
        default:
            firstly {
                self.countNumberManager.plassNumber()
            }.then { fecthCountNumber in
                self.countNumberManager.updataData(with: fecthCountNumber)
            }.then {
                self.countNumberManager.fecthData()
            }.then {_ in
                self.targetNumberManager.fecthTargetNumber()
            }.catch { err in
                self.showErrorAlert(title: "エラー", message: "操作をやり直してください")
            }.finally {
                self.achievementActionManager.achievementAction(countNumber: self.countNumberManager.fecthCountNumber, targetNumber: self.targetNumberManager.targetNumber)
            }
        }
        self.targetNumberManager.fecthTargetNumber()
        self.percent()
    }
    
    @IBAction func minusAction(_ sender: Any) {
        self.fostMinusNumber()
    }
    
    func fostMinusNumber() {
        if countNumberManager.fecthCountNumber == 0 {
            firstly {
                self.countNumberManager.deleteData()
            }.then {
                self.countNumberManager.minusCount()
            }.then { fecthCountNumber in
                self.countNumberManager.saveData(with: fecthCountNumber)
            }.then {
                self.countNumberManager.fecthData()
            }.catch { err in
                self.showErrorAlert(title: "エラー", message: "操作をやり直してください")
            }
        } else {
            firstly {
                self.countNumberManager.minusCount()
            }.then { fecthCountNumber in
                self.countNumberManager.updataData(with: fecthCountNumber)
            }.then {
                self.countNumberManager.fecthData()
            }.catch { err in
                self.showErrorAlert(title: "エラー", message: "操作をやり直してください")
            }
        }
        self.percent()
    }
    
    @IBAction func deleteAction(_ sender: Any) {
        firstly {
            self.countNumberManager.deleteData()
        }.done {
            self.countNumberManager.fecthData()
        }.catch { err in
            self.showErrorAlert(title: "エラー", message: "操作をやり直してください")
        }
        self.percent()
    }

    func percent() -> Promise<Void> {
        return Promise { resolver in
            if targetNumberManager.targetNumber == 0 {
                progressView.value = 0
            } else if countNumberManager.fecthCountNumber < 0 {
                print("何もしない")
            } else {
                var number = Float(countNumberManager.fecthCountNumber)
                print(number)
                var targetNumber = Float(targetNumberManager.targetNumber)
                print(targetNumber)
                achievementPercent = Float(number / targetNumber * 100)
                progressView.value = CGFloat(achievementPercent)
            }
            
            resolver.fulfill(())
        }
    }
    
    func showCountNumber() {
        countedNumberDisplayLabel.text = "\(countNumberManager.fecthCountNumber)"
        //self.textColor()
    }
    
    func decideTextColor() {
        countedNumberDisplayLabel.textColor = UIColor(hex: textColorManager.textColorData)
    }
    
    @IBAction func addTargetAction(_ sender: Any) {
        showActionSheet()
    }
    
    //NavigarionBarのTitleに目標回数を表示
    func showTarget() {
        if targetNumberManager.targetNumber == 0 {
            self.navigationItem.title = ""
        } else {
            self.navigationItem.title = "\(targetNumberManager.targetNumber)"
            self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        }
    }
    
    func showActionSheet() {
        // styleをActionSheetに設定
        let alertSheet = UIAlertController(title: "目標回数を設定", message: "目標回数を設定してください", preferredStyle: UIAlertController.Style.actionSheet)
        
        // 自分の選択肢を生成
        let setTargetAction = UIAlertAction(title: "目標回数設定", style: UIAlertAction.Style.default, handler: {
            (action: UIAlertAction!) in
            self.TargetSetAlert()
        })
        let deleteTargetAction = UIAlertAction(title: "目標回数を削除", style: UIAlertAction.Style.destructive, handler: {
            (action: UIAlertAction!) in
            self.targetNumberManager.deleteAchievement()
            self.targetNumberManager.fecthTargetNumber()
            self.percent()
        })
        let cancelAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler: {
            (action: UIAlertAction!) in
        })
        
        // アクションを追加.
        alertSheet.addAction(setTargetAction)
        alertSheet.addAction(deleteTargetAction)
        alertSheet.addAction(cancelAction)
        
        alertSheet.popoverPresentationController?.sourceView = self.view
        let screenSize = UIScreen.main.bounds
        alertSheet.popoverPresentationController?.sourceRect = CGRect(x: screenSize.size.width/2, y: screenSize.size.height, width: 0, height: 0)
        
        self.present(alertSheet, animated: true, completion: nil)
    }
    
    func TargetSetAlert() {
        var addTargeAlertTextField: UITextField?
        
        let alert = UIAlertController(
            title: "目標回数を入力",
            message: "数字のみ入力してください",
            preferredStyle: UIAlertController.Style.alert)
        alert.addTextField(
            configurationHandler: {(textField: UITextField!) in
                addTargeAlertTextField = textField
                textField.keyboardType = UIKeyboardType.numberPad
            })
        alert.addAction(
            UIAlertAction(
                title: "Cancel",
                style: UIAlertAction.Style.cancel,
                handler: nil))
        alert.addAction(
            UIAlertAction(
                title: "保存",
                style: UIAlertAction.Style.default) { _ in
                if let addTargeText = Int((addTargeAlertTextField?.text)!) {
                    
                    self.fostSetTarget(addTargeText: addTargeText)
                    self.targetNumberManager.fecthTargetNumber()
                    self.percent()
                }
            }
        )
        self.present(alert, animated: true, completion: nil)
    }
    
    func fostSetTarget(addTargeText: Int){
        if self.targetNumberManager.targetNumber == 0 {
            firstly {
                self.targetNumberManager.saveTargetNumber(with: addTargeText)
            }.then {
                self.targetNumberManager.fecthTargetNumber()
            }.catch { err in
                self.showErrorAlert(title: "エラー", message: "操作をやり直してください")
            }
            
        } else {
            firstly {
                self.targetNumberManager.updataTargetNumber(with: addTargeText)
            }.then {
                self.targetNumberManager.fecthTargetNumber()
            }.catch { err in
                self.showErrorAlert(title: "エラー", message: "操作をやり直してください")
            }
        }
        self.percent()
    }
    
    func startAchievementAnimation() {
        self.achievementAnimation = SwiftConfettiView(frame: self.view.bounds)
        self.bacgroundImageView.addSubview(achievementAnimation)
        //self.view.sendSubviewToBack(achievementAnimation)
        animationTypeConfigur()
        confettiAmountCounfigur()
        achievementAnimation.startConfetti()
    }
    
    func stopAchievementAnimation() {
        achievementAnimation.stopConfetti()
    }
    
    func removeAchievementAnimationView() {
        achievementAnimation.removeFromSuperview()
    }
    
    func animationTypeConfigur() {
        let fetchanimationType = UserDefaults.standard.string(forKey: "animationType")
        switch fetchanimationType {
        case "紙吹雪":
            achievementAnimation.type = .confetti
        case "さんかく":
            achievementAnimation.type = .triangle
        case "ひしがた":
            achievementAnimation.type = .diamond
        case "ほし":
            achievementAnimation.type = .star
        default:
            achievementAnimation.type = .confetti
        }
    }
    func confettiAmountCounfigur() {
        let fetchConfettiAmount = UserDefaults.standard.string(forKey: "ConfettiAmount")
        switch fetchConfettiAmount {
        case "レベル1":
            achievementAnimation.intensity = 0.3
        case "レベル2":
            achievementAnimation.intensity = 0.5
        case "レベル3":
            achievementAnimation.intensity = 0.8
        case "レベル4":
            achievementAnimation.intensity = 1.0
        default:
            achievementAnimation.intensity = 0.8
        }
    }
    //設置画面に遷移
    @IBAction func toCounfiguar(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Configur", bundle: Bundle.main)
        let rootConfigurViewContoroller = storyboard.instantiateViewController(withIdentifier: "Configur") as! ConfigurViewController
        self.navigationController?.pushViewController(rootConfigurViewContoroller, animated: true)
    }
}

extension UIViewController {
    func showErrorAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
        
    }
}

extension CountViewController:CoachMarksControllerDataSource, CoachMarksControllerDelegate{
    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkViewsAt index: Int, madeFrom coachMark: CoachMark) -> (bodyView: (UIView & CoachMarkBodyView), arrowView: (UIView & CoachMarkArrowView)?) {
        let coachViews = coachMarksController.helper.makeDefaultCoachViews(withArrow: true, withNextText: true, arrowOrientation: coachMark.arrowOrientation)
        coachViews.bodyView.hintLabel.text = self.messages[index]
        coachViews.bodyView.nextLabel.text = "OK"
        return (bodyView: coachViews.bodyView, arrowView: coachViews.arrowView)
    }
    
    func numberOfCoachMarks(for coachMarksController: CoachMarksController) -> Int {
        return self.messages.count
    }
    
    func coachMarksController(_ coachMarksController: CoachMarksController,
                              coachMarkAt index: Int) -> CoachMark {
        var views = [self.countedNumberDisplayLabel, self.minusButton, self.deleteButton]
        return coachMarksController.helper.makeCoachMark(for: views[index], pointOfInterest: nil, cutoutPathMaker: nil)
        
    }
}
