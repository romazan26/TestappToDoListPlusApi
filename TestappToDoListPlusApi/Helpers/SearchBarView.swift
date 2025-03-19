//
//  SearchBarView.swift
//  TestappToDoListPlusApi
//
//  Created by Роман Главацкий on 18.03.2025.
//

import SwiftUI

struct SearchBarView: View {
    @Binding var searchText: String
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.gray)
            TextField("Search", text: $searchText)
            
            Spacer()
            
            Button {
                searchText = ""
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .foregroundStyle(.gray)
            }
            }

            
        
        .padding()
        .background {
            Color.grayApp.cornerRadius(10)
        }
        
    }
}

#Preview {
    SearchBarView(searchText: .constant(""))
}
