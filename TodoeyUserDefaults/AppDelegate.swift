//
//  AppDelegate.swift
//  TodoeyUserDefaults
//
//  Created by Kajal on 1/9/18.
//  Copyright © 2018 Kajal. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
       // print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last! as String)
       // print(Realm.Configuration.defaultConfiguration.fileURL)
        do{
            //we are not using realm var so make it underscore
       // let realm = try Realm()
            _ = try Realm()
        }catch{
            print("error initilization while creating of realm\(error)")
        }
        return true
    }

   

}

