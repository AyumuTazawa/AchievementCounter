//
//  TextColorManager.swift
//  AchievementCounter
//
//  Created by 田澤歩 on 2020/12/23.
//  Copyright © 2020 net.ayumutazawa. All rights reserved.
//

import Foundation

protocol TextColorManagerDelegate {
    func decideTextColor()
}

class TextColorManager {
    
    var textColorData: String!
    var delegate: TextColorManagerDelegate?
    func textColorConfigur() {
        let fetchTextColor = UserDefaults.standard.string(forKey: "TextColor")
        self.textColorData = fetchTextColor
        switch textColorData {
        case "しろ":
            self.textColorData = "FFFFFF"
            delegate?.decideTextColor()
        case "くろ":
            self.textColorData = "000000"
            delegate?.decideTextColor()
        case "あお":
            self.textColorData = "0066FF"
            delegate?.decideTextColor()
        case "あか":
            self.textColorData = "FF0033"
            delegate?.decideTextColor()
        default:
            self.textColorData = "FFFFFF"
            delegate?.decideTextColor()
        }
    }
}
