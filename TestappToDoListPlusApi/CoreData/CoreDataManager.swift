//
//  CoreDataManager.swift
//  TestappToDoListPlusApi
//
//  Created by Роман Главацкий on 18.03.2025.
//
import Foundation
import CoreData

final class CoreDataManager {
    static let instance = CoreDataManager()
    
    let container: NSPersistentContainer
    var context: NSManagedObjectContext
    
    init() {
        container = NSPersistentContainer(name: "ToDoList")
        container.loadPersistentStores { descption, error in
            if let error = error{
                print("Error looading core data\(error)")
            }
        }
        context = container.viewContext
    }
    
    func save() {
        do {
            try context.save()
        }catch let error {
            print("Save data erroe \(error.localizedDescription)")
        }
        
    }
}
