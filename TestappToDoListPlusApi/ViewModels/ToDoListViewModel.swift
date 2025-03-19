//
//  ToDoListViewModel.swift
//  TestappToDoListPlusApi
//
//  Created by Роман Главацкий on 18.03.2025.
//

import Foundation
import CoreData
import Combine


final class ToDoListViewModel: ObservableObject {
    let manager = CoreDataManager.instance
    
    @Published var tasks: [Task] = []
    
    @Published var isEditMode: Bool = false
    
    //MARK: - Simple data propertys
    @Published var simpleTitle: String = ""
    @Published var simpleDescription: String = ""
    @Published var simpleIsCompleted: Bool = false
    @Published var simpleCreateDate = Date()
    @Published var simpleTask: Task?
    @Published var simpleShareText: String = ""
    
    //MARK: - Search propertys
        @Published var searchText: String = ""
        @Published var filteredTasks: [Task] = []
    
    //MARK: - Present propertys
    @Published var isPresentAddTask: Bool = false
    @Published var isPresentTaskInfo: Bool = false
    @Published var isPresentShareSheet: Bool = false
    
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        checkFirstLaunchAndFetchData()
        fetchTasks()
        filteredTasks = tasks
        
        $searchText
            .debounce(for: 0.5, scheduler: DispatchQueue.main)
            .combineLatest($tasks)
            .map { searchText, tasks in
                if searchText.isEmpty {
                    return tasks
                } else {
                    return tasks.filter {
                        $0.title?.lowercased().contains(searchText.lowercased()) ?? false
                    }
                }
            }
            .assign(to: \.self.filteredTasks, on: self)
            .store(in: &cancellables)
    }
    
    //MARK: - Network
    func checkFirstLaunchAndFetchData() {
            let hasLaunchedBefore = UserDefaults.standard.bool(forKey: "hasLaunchedBefore")
            
            if !hasLaunchedBefore {
                NetWorkManager.shared.fetchTodos { [weak self] todos in
                    if let todos = todos {
                        self?.saveTodosToCoreData(todos: todos)
                        UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
                    }
                }
            }
        }
    
    private func saveTodosToCoreData(todos: [TodoItem]) {
            DispatchQueue.global(qos: .background).async {
                let context = self.manager.context
                context.perform {
                    for todo in todos {
                        let task = Task(context: context)
                        task.title = todo.todo
                        task.isCompleted = todo.completed
                    }
                    do {
                        try context.save()
                    } catch {
                        print("Error saving context: \(error)")
                    }
                }
            }
        }
    
    //MARK: - Helper func
    func clearSimpleData() {
        self.simpleTitle = ""
        self.simpleDescription = ""
        self.simpleIsCompleted = false
        self.simpleCreateDate = Date()
    }
    
    func tapToEditTask(){
        isPresentTaskInfo.toggle()
        isPresentAddTask.toggle()
        isEditMode.toggle()
        guard let task = simpleTask else { return }
        simpleTitle = task.title ?? ""
        simpleDescription = task.taskDescription ?? ""
        
    }
    
    func toggleIsCompleted(task: Task){
        task.isCompleted.toggle()
        saveData()
    }
    
    func tapToShare(){
        guard let simpleTask = simpleTask else { return }
        simpleShareText = "\(simpleTask.title ?? "") \n \(simpleTask.taskDescription ?? "")\n  \(simpleTask.isCompleted ? "Completed" : "Not completed") "
        isPresentShareSheet = true
    }
    
    //MARK: - CoreData func    
    func deleteTask(){
            guard let task = simpleTask else { return }
            DispatchQueue.global(qos: .background).async {
                let context = self.manager.context
                context.perform {
                    context.delete(task)
                    do {
                        try context.save()
                        DispatchQueue.main.async {
                            self.isPresentTaskInfo.toggle()
                            self.fetchTasks()
                        }
                    } catch {
                        print("Error deleting task: \(error)")
                    }
                }
            }
        }
    
    func addTask() {
            DispatchQueue.global(qos: .background).async {
                let context = self.manager.context
                context.perform {
                    let task = Task(context: context)
                    task.title = self.simpleTitle
                    task.taskDescription = self.simpleDescription
                    task.createDate = self.simpleCreateDate
                    task.isCompleted = false
                    do {
                        try context.save()
                        DispatchQueue.main.async {
                            self.clearSimpleData()
                            self.isPresentAddTask.toggle()
                            self.fetchTasks()
                        }
                    } catch {
                        print("Error saving task: \(error)")
                    }
                }
            }
        }
    
    private func fetchTasks() {
           DispatchQueue.global(qos: .background).async {
               let context = self.manager.context
               context.perform {
                   let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
                   do {
                       let tasks = try context.fetch(fetchRequest)
                       DispatchQueue.main.async {
                           self.tasks = tasks
                           self.filteredTasks = tasks
                       }
                   } catch {
                       print("Fetching Error: \(error)")
                   }
               }
           }
       }
    
    private func saveData() {
            DispatchQueue.global(qos: .background).async {
                let context = self.manager.context
                context.perform {
                    do {
                        try context.save()
                        DispatchQueue.main.async {
                            self.fetchTasks()
                        }
                    } catch {
                        print("Error saving context: \(error)")
                    }
                }
            }
        }
}
