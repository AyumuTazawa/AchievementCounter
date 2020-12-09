//
//  CountNumberManager.swift
//  AchievementCounter
//
//  Created by 田澤歩 on 2020/12/02.
//  Copyright © 2020 net.ayumutazawa. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import PromiseKit

protocol CountNumberManagerDelegate: class {
    func showCountNumber()
}

class CountNumberManager {
    
    public var fecthCountNumber = Int()
    var getNumber = Int()
    weak var delgate: CountNumberManagerDelegate?
    var achievementActionManager: AchievementActionManager!
    static let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = appDelegate.persistentContainer.viewContext
    
    func plassNumber() -> Promise<Int> {
        return Promise { resolver in
            self.fecthCountNumber += 1
            resolver.fulfill(self.fecthCountNumber)
        }
    }
    
    func minusCount() -> Promise<Int> {
        return Promise { resolver in
            self.fecthCountNumber -= 1
            resolver.fulfill(fecthCountNumber)
        }
    }
    
    func saveData(with saveNumber: Int) -> Promise<Void> {
        return Promise { resolver in
            let entity = NSEntityDescription.entity(forEntityName: "CountNumber", in: context)
            let newCountedNumber = NSManagedObject(entity: entity!, insertInto: context)
            newCountedNumber.setValue(saveNumber, forKey: "countNumber")
            do{
                try context.save()
                
            }catch {
                print("err")
            }
            resolver.fulfill(())
        }
    }
    
    func fecthData() -> Promise<Int> {
        return Promise { resolver in
            let reqest = NSFetchRequest<NSFetchRequestResult>(entityName: "CountNumber")
            reqest.returnsObjectsAsFaults = false
            do{
                let result = try self.context.fetch(reqest)
                for data in result as! [NSManagedObject]{
                    self.getNumber = data.value(forKey: "countNumber") as! Int
                    self.fecthCountNumber = getNumber
                    self.delgate?.showCountNumber()
                }
            }catch{
                print("err")
            }
            resolver.fulfill(getNumber)
        }
    }
    
    func deleteData() -> Promise<Void> {
        return Promise { resolver in
            let reqest = NSFetchRequest<NSFetchRequestResult>(entityName: "CountNumber")
            reqest.returnsObjectsAsFaults = false
            do{
                let result = try context.fetch(reqest)
                print(result)
                
                for data in result as! [NSManagedObject]{
                    context.delete(data)
                    try context.save()
                    fecthCountNumber = 0
                    delgate?.showCountNumber()
                }
            }catch{
                print("err")
            }
            resolver.fulfill(())
        }
    }
    
    func updataData(with updataNumber: Int) -> Promise<Void> {
        return Promise { resolver in
            let reqest = NSFetchRequest<NSFetchRequestResult>(entityName: "CountNumber")
            reqest.returnsObjectsAsFaults = false
            let myResults = try! context.fetch(reqest)
            for data in myResults as! [NSManagedObject] {
                data.setValue(updataNumber, forKey: "countNumber")
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
