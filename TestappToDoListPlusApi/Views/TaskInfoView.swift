//
//  TaskInfiView.swift
//  TestappToDoListPlusApi
//
//  Created by Роман Главацкий on 18.03.2025.
//

import SwiftUI

struct TaskInfoView: View {
    @StateObject var vm: ToDoListViewModel
    var body: some View {
        ZStack {
            //MARK: - BackGround
            Color.black.opacity(0.8).ignoresSafeArea()
            if let task = vm.simpleTask {
                VStack(spacing: 15){
                    //MARK: - Task info
                    VStack(alignment: .leading) {
                        Text(task.title ?? "")
                            .foregroundStyle(.white)
                            .font(.system(size: 16))
                        Text(task.taskDescription ?? "")
                            .foregroundStyle(.white)
                            .font(.system(size: 12))
                        HStack {
                            Text(dateformatter(date: task.createDate ?? Date()))
                                .foregroundStyle(.gray)
                                .font(.system(size: 12))
                            Spacer()
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background {
                        Color.grayApp.cornerRadius(12)
                    }
                    
                    //MARK: - Menu
                    VStack(spacing: 12){
                        //MARK:  Edit button
                        Button {
                            vm.tapToEditTask()
                        } label: {
                            MenutaskButtonView(text: "Редактировать", image: "square.and.pencil")
                        }
                        Divider()
                        
                        //MARK: Share button
                        Button {
                            vm.tapToShare()
                        } label: {
                            MenutaskButtonView(text: "Поделиться", image: "square.and.arrow.up")
                        }
                        
                        Divider()
                        
                        //MARK: Delete button
                        Button {
                            vm.deleteTask()
                        } label: {
                            MenutaskButtonView(isRed: true, text: "Удалить", image: "trash")
                        }
                    }
                    .frame(width: 254, height: 120)
                    .padding()
                    .background {
                        Color.gray.cornerRadius(12)
                    }
                }
            }
        }
        .sheet(isPresented: $vm.isPresentShareSheet, content: {
            ShareSheet(items: vm.simpleShareText)
        })
        .onTapGesture {
            vm.isPresentTaskInfo.toggle()
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
    TaskInfoView(vm: ToDoListViewModel())
}
