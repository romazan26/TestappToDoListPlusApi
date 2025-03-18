//
//  ContentView.swift
//  TestappToDoListPlusApi
//
//  Created by Роман Главацкий on 18.03.2025.
//

import SwiftUI

struct ToDoListView: View {
    @StateObject var vm = ToDoListViewModel()
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                VStack {
                    Image(systemName: "globe")
                        .imageScale(.large)
                        .foregroundStyle(.tint)
                    Spacer()
                }
                .padding()
                HStack{
                    Spacer()
                    Text("\(vm.tasks.count) Задач")
                        .foregroundStyle(.white)
                    Spacer()
                    NavigationLink {
                        AddOrEditTaskView(vm: vm)
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
            }
            .ignoresSafeArea()
            .navigationTitle("Задачи")
        }
    }
}

#Preview {
    ToDoListView()
}
