//
//  Item.swift
//  TodoeyUserDefaults
//
//  Created by Kajal on 1/12/18.
//  Copyright © 2018 Kajal. All rights reserved.
//

import Foundation
import RealmSwift
class Item: Object
{
    @objc dynamic var  title : String = ""
    @objc dynamic var done : Bool = false
    //@objc dynamic var dateCreated : Date?
    //in category file  variable name as property
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
