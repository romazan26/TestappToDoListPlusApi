import XCTest
@testable import TestappToDoListPlusApi
import CoreData
import Combine

final class ToDoListViewModelTests: XCTestCase {
    
    var sut: ToDoListViewModel!
    var mockContext: NSManagedObjectContext!
    
    override func setUp() {
        super.setUp()
        
        // Setting in-memory CoreData stack for tests
        let persistentStoreDescription = NSPersistentStoreDescription()
        persistentStoreDescription.type = NSInMemoryStoreType
        
        let container = NSPersistentContainer(name: "ToDoList")
        container.persistentStoreDescriptions = [persistentStoreDescription]
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load in-memory CoreData store: \(error)")
            }
        }        
        mockContext = container.viewContext
        
        
        CoreDataManager.instance.context = mockContext
        sut = ToDoListViewModel()
    }
    
    override func tearDown() {
        sut = nil
        mockContext = nil
        super.tearDown()
    }
    
    func testFetchTasks() {
        // Создаем тестовую задачу
        let task = Task(context: mockContext)
        task.title = "Test Task"
        task.taskDescription = "Test Description"
        task.createDate = Date()
        task.isCompleted = false
        
        // Сохраняем задачу в CoreData
        try! mockContext.save()
        
        // Ожидание завершения асинхронных операций
        let expectation = self.expectation(description: "Tasks should be fetched from CoreData")
        
        sut.fetchTasks()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            // Проверяем, что задачи загружены
            XCTAssertFalse(self.sut.tasks.isEmpty, "Tasks should be fetched from CoreData")
            XCTAssertEqual(self.sut.tasks.first?.title, "Test Task", "Fetched task should match the created task")
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testAddTask() {
        // Устанавливаем тестовые данные
        sut.simpleTitle = "New Task"
        sut.simpleDescription = "New Description"
        sut.simpleCreateDate = Date()
        
        let expectation = self.expectation(description: "Task should be added and saved")
        
        sut.addTask()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            // Проверяем, что задача добавлена
            XCTAssertFalse(self.sut.tasks.isEmpty, "Tasks should not be empty after adding a task")
            XCTAssertEqual(self.sut.tasks.first?.title, "New Task", "Added task should match the input data")
            
            // Проверяем, что данные очищены
            XCTAssertTrue(self.sut.simpleTitle.isEmpty, "simpleTitle should be cleared after adding a task")
            XCTAssertTrue(self.sut.simpleDescription.isEmpty, "simpleDescription should be cleared after adding a task")
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testDeleteTask() {
        let task = Task(context: mockContext)
        task.title = "Task to Delete"
        task.taskDescription = "Description"
        task.createDate = Date()
        task.isCompleted = false
        try! mockContext.save()
        
        sut.simpleTask = task
        
        let expectation = self.expectation(description: "Task should be deleted")
        
        sut.deleteTask()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            // 6. Проверяем, что задача удалена
            XCTAssertFalse(self.sut.tasks.contains { $0.objectID == task.objectID }, "Task should be deleted from tasks")
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testToggleIsCompleted() {
        let task = Task(context: mockContext)
        task.title = "Test Task"
        task.isCompleted = false
        try! mockContext.save()
        
        sut.tasks.append(task)
        
        sut.toggleIsCompleted(task: task)
        
        //Проверяем, что состояние изменилось
        XCTAssertTrue(task.isCompleted, "Task should be completed after toggling")
    }
    
    func testSearchTasks() {
        //Создаем тестовые задачи
        let task1 = Task(context: mockContext)
        task1.title = "Task One"
        task1.taskDescription = "Description One"
        
        let task2 = Task(context: mockContext)
        task2.title = "Task Two"
        task2.taskDescription = "Description Two"
        
        try! mockContext.save()
        
        sut.tasks = [task1, task2]
        
        let expectation = self.expectation(description: "Search should filter tasks")
        
        // Устанавливаем текст для поиска
        sut.searchText = "One"
    
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            //Проверяем, что фильтрация работает
            XCTAssertEqual(self.sut.filteredTasks.count, 1, "Only one task should match the search text")
            XCTAssertEqual(self.sut.filteredTasks.first?.title, "Task One", "Filtered task should match the search text")
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2, handler: nil)
    }
    
}

    
