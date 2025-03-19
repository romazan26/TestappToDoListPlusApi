//
//  AddOrEditTaskView.swift
//  TestappToDoListPlusApi
//
//  Created by Роман Главацкий on 18.03.2025.
//

import SwiftUI

struct AddOrEditTaskView: View {
    @StateObject var vm: ToDoListViewModel
    @FocusState var isFocused: Bool
    var body: some View {
        VStack{
            //MARK: - Title task
            TextField("Название", text: $vm.simpleTitle)
                .focused($isFocused)
                .foregroundStyle(.white)
                .font(.system(size: 34))
            
            //MARK: - Create date task
            DatePicker("Дата создания задачи", selection: $vm.simpleCreateDate,displayedComponents: .date)
                .foregroundStyle(.gray)
            
            //MARK: - Description tasl
            ZStack(alignment: .topLeading) {
                TextEditor(text: $vm.simpleDescription)
                    .focused($isFocused)
                    .foregroundStyle(.white)
                if vm.simpleDescription.isEmpty {
                    Text("Описание задачи")
                       .padding(8)
                        .foregroundStyle(.gray)
                }
            }
            
            Spacer()
            
            //MARK: - Save task button
            Button {
                vm.addTask()
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundStyle(.grayApp)
                        .frame(height: 50)
                    Text("Сохранить")
                        .bold()
                }.opacity(vm.simpleTitle.isEmpty ? 0.5 : 1)
            }.disabled(vm.simpleTitle.isEmpty)

        }
        .padding()
        .onDisappear {
            vm.clearSimpleData()
        }
        .onTapGesture {
            isFocused = false
        }
    }
}

#Preview {
    AddOrEditTaskView(vm: ToDoListViewModel())
}
