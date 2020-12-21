//
//   RipplesManagaer.swift
//  AchievementCounter
//
//  Created by 田澤歩 on 2020/12/21.
//  Copyright © 2020 net.ayumutazawa. All rights reserved.
//

import Foundation
import UIKit

protocol RipplesManagaerDelegate: class {
    func showRipples(touchData: UITapGestureRecognizer)
}

class RipplesManagaer {
    weak var delgate: RipplesManagaerDelegate?
    var configuerViewController = ConfigurViewController()
    var coutViewContoroller = CountViewController()
    
    func ripplesConfiguer(touchData: UITapGestureRecognizer) {
        self.configuerViewController.fetchripplesValue = UserDefaults.standard.bool(forKey: "Ripples")
        if self.configuerViewController.fetchripplesValue == true {
            //self.coutViewContoroller.view.ripples(touch: touchData)
            self.delgate?.showRipples(touchData: touchData)
        } else if self.configuerViewController.fetchPuhValue == false {
            print("何もしない")
        }
    }
}
