//
//  TodoListModel.swift
//  Sync-Schedule
//
//  Created by Olar's Mac on 9/4/18.
//  Copyright © 2018 trybetech LTD. All rights reserved.
//

import RealmSwift
import SyncKit

class TodoListModel: Object, QSPrimaryKey, QSParentKey {
    
    @objc dynamic var id = UUID().uuidString
    let sortIndex = RealmOptional<Int>()
    @objc dynamic var name: String = ""
    @objc dynamic var desc: String = "No Description"
//    let photo = List<Data>()
    @objc dynamic var photo: Data? = nil
    @objc dynamic var createdDate: Date?
    @objc dynamic var remiderDate: Date?
    @objc dynamic var isCompleted = false
 
    @objc dynamic var category: CategoryModel?
    
//    let parentCategory = LinkingObjects(fromType: CategoryModel.self, property: "items")
//
//
    override static func primaryKey() -> String {
        return "id"
    }
    
    static func parentKey() -> String {
        return "category"
    }


}
