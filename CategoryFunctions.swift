//
//  TripFunctions.swift
//  Itinerary
//
//  Created by Olar's Mac on 8/24/18.
//  Copyright © 2018 trybetech LTD. All rights reserved.
//

import UIKit
import RealmSwift
import SyncKit

class CategoryFunctions {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    private var database:Realm!
    static let instance = CategoryFunctions()
    
    var categoryArray: Results<CategoryModel>?
    var notificationToken: NotificationToken!
    let category = CategoryModel()
    
    private init() {
//        var db = appDelegate.realm
        database = appDelegate.realm
        database = try! Realm(configuration: appDelegate.realmConfiguration)
    }
    
    
    //MARK:- Add Category Function
    func addData(object: CategoryModel)   {
        try! database.write {
            database.add(object)
        }
    }
    
    //MARK:- Get Category
    func getDataFromDB() -> Results<CategoryModel> {
        let categoryArray: Results<CategoryModel> = database.objects(CategoryModel.self)
        return categoryArray
    }
    
    
    //MARK:- Create Category
    func createCategory(name: String, color: String, isCompleted: Bool) -> Void {

        let category = CategoryModel()
        category.name = name
        category.color = color
        category.isCompleted = false
        categoryArray = database.objects(CategoryModel.self).sorted(byKeyPath: "sortIndex")
        category.sortIndex.value = CategoryFunctions.instance.categoryArray!.count
        CategoryFunctions.instance.addData(object: category)
        
    }

    
    
    //MARK:- Update Category
    func toggleCompleted(object: CategoryModel) {
        try! database.write {
            object.isCompleted = !object.isCompleted
        }
    }
    
    
    //MARK:- Delete Category
    func deleteAllFromDatabase()  {
        try! database.write {
            database.deleteAll()
        }
    }
    
    //MARK:- Delete Category Items
    func deleteCategoryItems(object: List<TodoListModel>)  {
        try! database.write {
            database.delete(object)
        }
    }

    
    func deleteFromDb(object: CategoryModel)   {
        try! database.write {
            database.delete(object)
        }
    }
    
    
}
