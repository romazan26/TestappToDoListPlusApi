//
//  ToDoListViewModel.swift
//  TestappToDoListPlusApi
//
//  Created by Роман Главацкий on 18.03.2025.
//

import Foundation
import CoreData


final class ToDoListViewModel: ObservableObject {
    let manager = CoreDataManager.instance
    
    @Published var tasks: [Task] = []
    
    //MARK: - Simple data propertys
    @Published var simpleTitle: String = ""
    @Published var simpleDescription: String = ""
    @Published var simpleIsCompleted: Bool = false
    @Published var simpleCreateDate = Date()
    
    init() {
        fetchTasks()
    }
    
    //MARK: - Helper func
    func clearSimpleData() {
        self.simpleTitle = ""
        self.simpleDescription = ""
        self.simpleIsCompleted = false
        self.simpleCreateDate = Date()
    }
    
    //MARK: - CoreData func
    func deleteTask(task: Task){
        manager.context.delete(task)
        saveData()
    }
    
    func addTask() {
        let task = Task(context: manager.context)
        task.title = simpleTitle
        task.taskDescription = simpleDescription
        task.createDate = simpleCreateDate
        task.isCompleted = false
        saveData()
        clearSimpleData()
    }
    
    private func fetchTasks() {
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        do {
            tasks = try manager.context.fetch(fetchRequest)
        } catch {
            print("Fetching Error: \(error)")
        }
    }
    
    private func saveData() {
        tasks.removeAll()
        manager.save()
        fetchTasks()
    }
}
