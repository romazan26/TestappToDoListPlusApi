//
//  TaskCellView.swift
//  TestappToDoListPlusApi
//
//  Created by Роман Главацкий on 18.03.2025.
//

import SwiftUI

struct TaskCellView: View {
    @ObservedObject var task: Task
    var tabOnIsCompleted: () -> Void = { }
    var body: some View {
        HStack(alignment: .top) {
            Button {
                tabOnIsCompleted()
            } label: {
                Image(systemName: task.isCompleted ? "xmark.circle" : "circle")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundStyle(task.isCompleted ? .yellow : .gray)
            }
            
            VStack(alignment: .leading, spacing: 10){
                //MARK: - Title task
                Text(task.title ?? "")
                    .multilineTextAlignment(.leading)
                    .font(.system(size: 18))
                    .foregroundStyle(task.isCompleted ? .gray : .white)
                    .strikethrough(task.isCompleted)
                
                //MARK: - Description task
                Text(task.taskDescription ?? "")
                    .multilineTextAlignment(.leading)
                    .font(.system(size: 12))
                    .foregroundStyle(task.isCompleted ? .gray : .white)
                
                //MARK: - Create date task
                Text(dateformatter(date: task.createDate ?? Date()))
                    .font(.system(size: 12))
                    .foregroundStyle(.gray)
            }
            Spacer()
        }
    }
    //MARK: - Dateformatter
    private func dateformatter(date: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        return dateFormatter.string(from: date)
    }

}

#Preview {
    TaskCellView(task: Task(context: CoreDataManager.instance.context))
}
