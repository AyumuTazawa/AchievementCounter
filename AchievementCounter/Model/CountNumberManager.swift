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

protocol CountNumberManagerDelegate: class {
    func showCountNumber()
}

class CountNumberManager {
    
    public var fecthCountNumber = Int()
    weak var delgate: CountNumberManagerDelegate?
    var achievementActionManager: AchievementActionManager!
    static let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = appDelegate.persistentContainer.viewContext
    
    
    func plassNumber() {
        if fecthCountNumber == nil {
            var plassnumber = 0
            plassnumber += 1
            fecthCountNumber = plassnumber
            delgate?.showCountNumber()
        } else {
            fecthCountNumber += 1
            delgate?.showCountNumber()
        }
    }
    
    func minusCount() {
        if fecthCountNumber == nil {
            var plassnumber = 0
            plassnumber -= 1
            fecthCountNumber = plassnumber
            delgate?.showCountNumber()
        } else {
            fecthCountNumber -= 1
            delgate?.showCountNumber()
        }
    }

    
    func saveData(with saveNumber: Int) {
        let entity = NSEntityDescription.entity(forEntityName: "CountNumber", in: context)
        let newCountedNumber = NSManagedObject(entity: entity!, insertInto: context)
        //let saveData = saveNumber
        newCountedNumber.setValue(saveNumber, forKey: "countNumber")
        do{
            try context.save()
            print("save")
        }catch {
            print("err")
        }
    }
    
    func fecthData() {
        let reqest = NSFetchRequest<NSFetchRequestResult>(entityName: "CountNumber")
        reqest.returnsObjectsAsFaults = false
        do{
            let result = try context.fetch(reqest)
            for data in result as! [NSManagedObject]{
                let getNumber = data.value(forKey: "countNumber") as! Int
                fecthCountNumber = getNumber
                delgate?.showCountNumber()
            }
        }catch{
            print("err")
        }
    }
    
    func deleteData() {
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
    }
    
    func updataData(with updataNumber: Int) {
           let reqest = NSFetchRequest<NSFetchRequestResult>(entityName: "CountNumber")
           reqest.returnsObjectsAsFaults = false
           let myResults = try! context.fetch(reqest)
           for data in myResults as! [NSManagedObject] {
               data.setValue(updataNumber, forKey: "countNumber")
               print("アップデーと")
           }
           do{
               try context.save()
               print("save")
           }catch {
               print("err")
           }
       }
}
