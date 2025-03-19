//
//  NetWorkManager.swift
//  TestappToDoListPlusApi
//
//  Created by Роман Главацкий on 19.03.2025.
//

import Foundation

struct TodoItem: Codable {
    let id: Int
        let todo: String
        let completed: Bool
        let userId: Int
}

struct TodoItemResponse: Codable {
    let todos: [TodoItem]
}

final class NetWorkManager {
    private let urlString = "https://dummyjson.com/todos"
    static let shared = NetWorkManager()
    
    private init() {}
    
    func fetchTodos(completion: @escaping ([TodoItem]?) -> Void) {
           guard let url = URL(string: "https://dummyjson.com/todos") else {
               completion(nil)
               return
           }
           
           URLSession.shared.dataTask(with: url) { data, response, error in
               guard let data = data, error == nil else {
                   completion(nil)
                   return
               }
               
               do {
                   let response = try JSONDecoder().decode(TodoItemResponse.self, from: data)
                   completion(response.todos)
               } catch {
                   print("Error decoding JSON: \(error)")
                   completion(nil)
               }
           }.resume()
       }
}
