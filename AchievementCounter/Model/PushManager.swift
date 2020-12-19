//
//  PushManager.swift
//  AchievementCounter
//
//  Created by 田澤歩 on 2020/12/19.
//  Copyright © 2020 net.ayumutazawa. All rights reserved.
//

import Foundation
import UIKit
import AudioToolbox

class PushManager {
    
    var configuerViewController = ConfigurViewController()
    
    //プッシュ通知設置
    func pushConfigur() {
        self.configuerViewController.fetchPuhValue = UserDefaults.standard.bool(forKey: "Push")
        if self.configuerViewController.fetchPuhValue == true {
            let content = UNMutableNotificationContent()
            content.title = "目標達成！！"
            content.body = "どんどん頑張ろう！"
            content.sound = UNNotificationSound.default
            let request = UNNotificationRequest(identifier: "immediately", content: content, trigger: nil)
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        } else if self.configuerViewController.fetchPuhValue == false {
            print("何もしない")
        }
    }
}
