//
//  TripModel.swift
//  Itinerary
//
//  Created by Olar's Mac on 8/24/18.
//  Copyright © 2018 trybetech LTD. All rights reserved.
//

import RealmSwift
import SyncKit

class CategoryModel: Object, QSPrimaryKey {
    
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var name : String = ""
    @objc dynamic var color : String = ""
    @objc dynamic var isCompleted = false
    
    
    // relationship with Items
    // List is d substitute for array in Realm
    let sortIndex = RealmOptional<Int>()
    let items = List<TodoListModel>()

    let itemsz = LinkingObjects(fromType: TodoListModel.self, property: "category")

    override static func primaryKey() -> String {
        return "id"
    }
    
 
    
    
}
