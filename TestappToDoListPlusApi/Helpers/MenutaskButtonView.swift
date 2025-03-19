//
//  MenutaskButtonView.swift
//  TestappToDoListPlusApi
//
//  Created by Роман Главацкий on 18.03.2025.
//

import SwiftUI

struct MenutaskButtonView: View {
    var isRed: Bool = false
    var text: String
    var image: String
    var body: some View {
        HStack {
            Text(text)
            Spacer()
            Image(systemName: image)
        }
        .foregroundStyle(isRed ? .red : .black)
        .font(.system(size: 17))
    }
}

#Preview {
    ZStack {
        Color.gray
        MenutaskButtonView(text: "Edit", image: "square.and.pencil")
    }
}
