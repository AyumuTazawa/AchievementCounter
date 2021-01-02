//
//  SplashViewController.swift
//  AchievementCounter
//
//  Created by 田澤歩 on 2021/01/01.
//  Copyright © 2021 net.ayumutazawa. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {
    
    var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(hex: "7bdcd0")
        
        self.imageView = UIImageView(frame: CGRect(x:0, y:0, width: 100, height: 100))
        
        self.imageView.center = self.view.center
        
        self.imageView.image = UIImage(named: "appstore.png")
        
        self.view.addSubview(self.imageView)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.3,
                       delay: 1.0,
                       options: UIView.AnimationOptions.curveEaseOut,
                       animations: { () in
                        self.imageView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                       }, completion: { (Bool) in
                        
                       })
        
        UIView.animate(withDuration: 0.2,
                       delay: 1.3,
                       options: UIView.AnimationOptions.curveEaseOut,
                       animations: { () in
                        self.imageView.transform = CGAffineTransform(scaleX: 8.0, y: 8.0)
                        self.imageView.alpha = 0
                       }, completion: { (Bool) in
                        
                        self.imageView.removeFromSuperview()
                        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let nextView = storyboard.instantiateViewController(withIdentifier: "Main") as! UINavigationController
                        nextView.modalTransitionStyle = .crossDissolve
                        nextView.modalPresentationStyle = .fullScreen
                        self.present(nextView, animated: false, completion: nil)
                       })
    }
    
    
}
