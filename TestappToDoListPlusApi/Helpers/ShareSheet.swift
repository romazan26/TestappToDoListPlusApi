//
//  Untitled.swift
//  TestappToDoListPlusApi
//
//  Created by Роман Главацкий on 19.03.2025.
//
import Foundation
import SwiftUI

struct ShareSheet: UIViewControllerRepresentable{
    var items: String
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let av = UIActivityViewController(activityItems: [items], applicationActivities: nil)
        return av
    }
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}
