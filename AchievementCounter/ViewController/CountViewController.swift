//
//  CountViewController.swift
//  AchievementCounter
//
//  Created by 田澤歩 on 2020/12/02.
//  Copyright © 2020 net.ayumutazawa. All rights reserved.
//

import UIKit
import SwiftConfettiView


class CountViewController: UIViewController, UIGestureRecognizerDelegate, CountNumberManagerDelegate, TargetNumberManagerDelegate, AchievementActionManagerDelegate {
    
    var achievementAnimation: SwiftConfettiView!
    var countNumberManager: CountNumberManager!
    var targetNumberManager: TargetNumberManager!
    var achievementActionManager: AchievementActionManager!
    
    @IBOutlet weak var countedNumberDisplayLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var minusButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.countNumberManager = CountNumberManager()
        self.targetNumberManager = TargetNumberManager()
        self.achievementActionManager = AchievementActionManager()
        
        countNumberManager.delgate = self
        targetNumberManager.delgate = self
        achievementActionManager.delgate = self
        
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
        countNumberManager.fecthData()
        print(countNumberManager.fecthCountNumber)
        //navigationTitleセット
        targetNumberManager.fecthTargetNumber()
    }
    
    @objc func tapped(_ sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            print("tap")
            addNumber()
        }
    }
    
    func addNumber() {
        if countNumberManager.fecthCountNumber == 0 {
            countNumberManager.plassNumber()
            countNumberManager.saveData(with: countNumberManager.fecthCountNumber)
            print("新規追加")
        } else {
            countNumberManager.plassNumber()
            countNumberManager.updataData(with: countNumberManager.fecthCountNumber)
            print("アップデート")
        }

        countNumberManager.fecthData()
        targetNumberManager.fecthTargetNumber()
        achievementActionManager.achievementAction(countNumber: countNumberManager.fecthCountNumber, targetNumber: targetNumberManager.targetNumber)
    }
    
    
    @IBAction func minusAction(_ sender: Any) {
        minusNumber()
    }
    
    func minusNumber() {
        switch countNumberManager.fecthCountNumber {
        case 0:
            countNumberManager.minusCount()
            countNumberManager.saveData(with: countNumberManager.fecthCountNumber)
            countNumberManager.fecthData()
        default:
            countNumberManager.minusCount()
            countNumberManager.updataData(with: countNumberManager.fecthCountNumber)
            countNumberManager.fecthData()
        }
    }
    
    @IBAction func deleteAction(_ sender: Any) {
        countNumberManager.deleteData()
        countNumberManager.fecthData()
    }
    
    func showCountNumber() {
        countedNumberDisplayLabel.text = "\(countNumberManager.fecthCountNumber)"
        
    }
    
    @IBAction func addTargetAction(_ sender: Any) {
        showActionSheet()
        
    }
    
    //NavigarionBarのTitleに目標回数を表示
    func showTarget() {
        self.navigationItem.title = "\(targetNumberManager.targetNumber)"
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    func showActionSheet() {
        // styleをActionSheetに設定
        let alertSheet = UIAlertController(title: "目標回数を設定", message: "目標回数を設定してください", preferredStyle: UIAlertController.Style.actionSheet)
        
        // 自分の選択肢を生成
        let action1 = UIAlertAction(title: "設定", style: UIAlertAction.Style.default, handler: {
            (action: UIAlertAction!) in
            self.TargetSetAlert()
        })
        let action2 = UIAlertAction(title: "削除", style: UIAlertAction.Style.destructive, handler: {
            (action: UIAlertAction!) in
            self.targetNumberManager.deleteAchievement()
        })
        let action3 = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler: {
            (action: UIAlertAction!) in
        })
        
        // アクションを追加.
        alertSheet.addAction(action1)
        alertSheet.addAction(action2)
        alertSheet.addAction(action3)
        
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
                    if let text = Int((addTargeAlertTextField?.text)!) {
                        print(text)
                        switch self.targetNumberManager.targetNumber {
                        case 0:
                            self.targetNumberManager.saveTargetNumber(with: text)
                            self.targetNumberManager.fecthTargetNumber()
                        default:
                            self.targetNumberManager.updataTargetNumber(with: text)
                            self.targetNumberManager.fecthTargetNumber()
                        }
                    }
            }
        )
        self.present(alert, animated: true, completion: nil)
    }
    
    func startAchievementAnimation() {
        self.achievementAnimation = SwiftConfettiView(frame: self.view.bounds)
        self.view.addSubview(achievementAnimation)
        achievementAnimation.type = .diamond
        achievementAnimation.intensity = 0.8
        achievementAnimation.startConfetti()
    }
    
    func stopAchievementAnimation() {
        achievementAnimation.stopConfetti()
    }
    
    func removeAchievementAnimationView() {
        achievementAnimation.removeFromSuperview()
    }
}
