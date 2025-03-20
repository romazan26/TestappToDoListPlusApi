//
//  ContentView.swift
//  TestappToDoListPlusApi
//
//  Created by Роман Главацкий on 18.03.2025.
//

import SwiftUI

struct ToDoListView: View {
    @StateObject var vm = ToDoListViewModel()
    @FocusState private var isFocused: Bool
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                VStack(spacing: 20) {
                    //MARK: - Search bar
                    SearchBarView(searchText: $vm.searchText)
                        .focused($isFocused)
                    
                    //MARK: - List of tasks
                    if vm.filteredTasks.isEmpty {
                        Text("Нет задач")
                            .foregroundColor(.gray)
                    }else{
                        ScrollView {
                            LazyVStack {
                                ForEach(vm.filteredTasks) { task in
                                    Button {
                                        vm.simpleTask = task
                                        vm.isPresentTaskInfo.toggle()
                                    } label: {
                                        TaskCellView(task: task) {
                                            vm.toggleIsCompleted(task: task)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                    Spacer()
                }
                .onTapGesture {
                    isFocused = false
                }
                .padding()
                
                //MARK: - Bottom tool bar
                HStack{
                    Spacer()
                    Text("\(vm.tasks.count) Задач")
                        .foregroundStyle(.white)
                    Spacer()
                    Button {
                        vm.isPresentAddTask.toggle()
                    } label: {
                        Image(systemName: "square.and.pencil")
                            .resizable()
                            .frame(width: 30, height: 30)
                    }
                }
                .padding(.horizontal, 20)
                .frame(height: 85)
                .frame(maxWidth: .infinity)
                .background(Color.grayApp)
                
                //MARK: - Task info
                if vm.isPresentTaskInfo {
                    TaskInfoView(vm: vm)
                }
            }
            .onTapGesture {
                isFocused = false
            }
            .ignoresSafeArea(edges: .bottom)
            .navigationTitle("Задачи")
            .navigationDestination(isPresented: $vm.isPresentAddTask) {
                AddOrEditTaskView(vm: vm)
            }
            .animation(.easeInOut, value: vm.isPresentTaskInfo)
        }
    }
}

#Preview {
    ToDoListView()
}
