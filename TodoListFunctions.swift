//
//  TodoListFunctions.swift
//  Sync-Schedule
//
//  Created by Olar's Mac on 9/4/18.
//  Copyright © 2018 trybetech LTD. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListFunctions {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private var database:Realm
    static let instance = TodoListFunctions()
    
    
    
    var todoListArray: Results<TodoListModel>?
    
    var todoItems : Results<TodoListModel>?
    
    var selectedCategory : CategoryModel?
    var selectedImage : TodoListModel?
    var selectedImage1 : TodoListModel?
    
    private init() {
        database = appDelegate.realm
        database = try! Realm(configuration: appDelegate.realmConfiguration)
    }
    
    
    
    //MARK:- Add TodoList Function
    func addData(object: TodoListModel)   {
        
        try! database.write {
            if let currentCategory = selectedCategory {
                database.add(object, update: true)
                currentCategory.items.append(object)
            }
        }
    }
    
    //MARK:- Get TodoList
    func getDataFromDB() -> Results<TodoListModel>? {
        let todoListArray: Results<TodoListModel> = database.objects(TodoListModel.self)
        return todoListArray
    }
    
    
    //MARK:- Create TodoList
    func createTodoList(name: String, description: String, createdDate: Date, remiderDate: Date, photo: Data/*Array<Data>*/, isCompleted: Bool) -> Void {
        
            let todoList = TodoListModel()
        
        if name != "" {
            todoList.name = name
        } else {
            todoList.name = "No extra information"
        }
        
            todoList.desc = description
            todoList.createdDate = createdDate
            todoList.remiderDate = remiderDate
            todoList.photo = photo
        let predicate = NSPredicate(format: "category == %@", selectedCategory!)
        todoItems = database.objects(TodoListModel.self).filter(predicate).sorted(byKeyPath: "sortIndex")
//            todoList.photo.append(objectsIn: photo)
            todoList.isCompleted = false
        todoList.category = selectedCategory
        todoList.sortIndex.value = TodoListFunctions.instance.todoItems?.count
            TodoListFunctions.instance.addData(object: todoList)
  
    }
    
    
    func updateTodoList(update: TodoListModel, name: String, description: String, createdDate: Date, remiderDate: Date, photo: Data/*Array<Data>*/, isCompleted: Bool) -> Void {
        
//        DispatchQueue(label: "background").async {
//            autoreleasepool {
//                let realm = try! Realm()
//                let theDog = realm.objects(Dog.self).filter("age == 1").first
//                try! realm.write {
//                    theDog!.age = 3
//                }
//            }
//        }
        
//        DispatchQueue(label: "background").async {
//            autoreleasepool {

//                let update = self.database.objects(TodoListModel.self).first!
                
                try! self.database.write {
                    
                    if name != "" {
                        update.name = name
                    } else {
                        update.name = "No extra information"
                    }
                    
                    update.desc = description
                    update.createdDate = createdDate
                    update.remiderDate = remiderDate
                    update.photo = photo
//                    for i in 0..<photo.count {
//                        if photo[i] != nil {
//                            update.photo[i] = photo
////                            myArray[i]!.customValue = "Hello"
//                        }
//                    }
//                    update.photo.append(objectsIn: photo)
                    update.isCompleted = false

//                    self.database.add(update, update: true)
                }
//            }
//        }

        
    }
    
    
    //MARK:- Update TodoList
    func updateTodoItem(object: TodoListModel) {
        try! database.write {
            
//            database.
            object.isCompleted = !object.isCompleted
        }
    }
    
    
    //MARK:- Update TodoList
    func toggleCompleted(object: TodoListModel) {
        try! database.write {
            object.isCompleted = !object.isCompleted
        }
    }
    
    
    
    
    //MARK:- Delete TodoList
    func deleteAllFromDatabase()  {
        try! database.write {
            database.deleteAll()
        }
    }
    
    
    func deleteFromDb(object: TodoListModel)   {
        try! database.write {
            database.delete(object)
        }
    }
}
