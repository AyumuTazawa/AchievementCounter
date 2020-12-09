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
import PromiseKit

protocol  TargetNumberManagerDelegate: class {
    func showTarget()
}

class  TargetNumberManager {
    
    public var targetNumber = Int()
    weak var delgate: TargetNumberManagerDelegate?
    static let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = appDelegate.persistentContainer.viewContext
    
     func saveTargetNumber(with saveTarget: Int) -> Promise<Void> {
        return Promise { resolver in
            let entity = NSEntityDescription.entity(forEntityName: "TargetNumber", in: context)
            let newTargetNumber = NSManagedObject(entity: entity!, insertInto: context)
            newTargetNumber.setValue(saveTarget, forKey: "targetNumber")
            do{
                try context.save()
            }catch {
                print("err")
            }
             resolver.fulfill(())
        }
    }
    
    func fecthTargetNumber() -> Promise<Int> {
        return Promise { resolver in
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
            resolver.fulfill(targetNumber)
        }
    }
    
    func deleteAchievement() -> Promise<Void> {
        return Promise { resolver in
            let reqest = NSFetchRequest<NSFetchRequestResult>(entityName: "TargetNumber")
            reqest.returnsObjectsAsFaults = false
            do {
                let result = try context.fetch(reqest)
                for data in result as! [NSManagedObject]{
                    context.delete(data)
                    try context.save()
                    self.targetNumber = 0
                    delgate?.showTarget()
                }
            } catch {
                print("err")
            }
            resolver.fulfill(())
        }
    }
    
    func updataTargetNumber(with updataTarget: Int) -> Promise<Void> {
        return Promise { resolver in
            let reqest = NSFetchRequest<NSFetchRequestResult>(entityName: "TargetNumber")
                   reqest.returnsObjectsAsFaults = false
                   let myResults = try! context.fetch(reqest)
                   for data in myResults as! [NSManagedObject] {
                       data.setValue(updataTarget, forKey: "targetNumber")
                   }
                   do{
                       try context.save()
                   }catch {
                       print("err")
                   }
             resolver.fulfill(())
        }
    }
    
}
