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
        
        //角丸の程度を指定
        //self.deleteButton.layer.cornerRadius = 40.0
        
        //カウント回数を表示
        countNumberManager.fecthData()
        //navigationTitleセット
        targetNumberManager.fecthTargetNumber()
    }
    
    @objc func tapped(_ sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            print("tap")
            countNumberManager.plassNumber()
            countNumberManager.saveData(with: countNumberManager.fecthCountNumber)
            countNumberManager.fecthData()
            targetNumberManager.fecthTargetNumber()
            achievementActionManager.achievementAction(countNumber: countNumberManager.fecthCountNumber, targetNumber: targetNumberManager.targetNumber)
        }
    }
    
    
    @IBAction func minusAction(_ sender: Any) {
        countNumberManager.minusCount()
        countNumberManager.saveData(with: countNumberManager.fecthCountNumber)
        countNumberManager.fecthData()
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
    }
    
    func showActionSheet() {
        // styleをActionSheetに設定
        let alertSheet = UIAlertController(title: "title", message: "message", preferredStyle: UIAlertController.Style.actionSheet)
        
        // 自分の選択肢を生成
        let action1 = UIAlertAction(title: "目標回数を設定", style: UIAlertAction.Style.default, handler: {
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
                        self.targetNumberManager.saveTargetNumber(with: text)
                        self.targetNumberManager.fecthTargetNumber()
                    }
            }
        )
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func startAchievementAnimation() {
        self.achievementAnimation = SwiftConfettiView(frame: self.view.bounds)
        self.view.addSubview(achievementAnimation)
        achievementAnimation.type = .diamond
        achievementAnimation.startConfetti()
        
    }
    
    func stopAchievementAnimation() {
        achievementAnimation.stopConfetti()
    }
    
    func removeAchievementAnimationView() {
        achievementAnimation.removeFromSuperview()
    }
}
