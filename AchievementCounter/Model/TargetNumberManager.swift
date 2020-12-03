//
//  TargetNumberManager.swift
//  AchievementCounter
//
//  Created by 田澤歩 on 2020/12/02.
//  Copyright © 2020 net.ayumutazawa. All rights reserved.
//

import Foundation
import UIKit
import CoreData

protocol  TargetNumberManagerDelegate: class {
   func showTarget()
}

class  TargetNumberManager {
    
    public var targetNumber = Int()
    weak var delgate: TargetNumberManagerDelegate?
    static let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = appDelegate.persistentContainer.viewContext
    
    
    func saveTargetNumber(with saveTarget: Int) {
        let entity = NSEntityDescription.entity(forEntityName: "TargetNumber", in: context)
        let newTargetNumber = NSManagedObject(entity: entity!, insertInto: context)
       newTargetNumber.setValue(saveTarget, forKey: "targetNumber")
        print(saveTarget)
            do{
                try context.save()
                print("save")
            }catch {
                print("err")
            }
    }
    
    func fecthTargetNumber() {
        let reqest = NSFetchRequest<NSFetchRequestResult>(entityName: "TargetNumber")
        reqest.returnsObjectsAsFaults = false
        do{
            let result = try context.fetch(reqest)
            for data in result as! [NSManagedObject]{
                let getNumber = data.value(forKey: "targetNumber") as! Int
                self.targetNumber = getNumber
                delgate?.showTarget()
            }
        }catch{
            print("err")
        }
    }
    
    func deleteAchievement() {
        let reqest = NSFetchRequest<NSFetchRequestResult>(entityName: "TargetNumber")
        reqest.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(reqest)
            for data in result as! [NSManagedObject]{
                context.delete(data)
                try context.save()
                print("削除完了")
                self.targetNumber = 0
                delgate?.showTarget()
            }
        } catch {
            print("err")
        }
    }
    
}
