//
//  Category.swift
//  TodoeyUserDefaults
//
//  Created by Kajal on 1/12/18.
//  Copyright © 2018 Kajal. All rights reserved.
//

import Foundation
import RealmSwift
class Category: Object
{
    @objc dynamic var  name : String = ""
    let items = List<Item>()
}
