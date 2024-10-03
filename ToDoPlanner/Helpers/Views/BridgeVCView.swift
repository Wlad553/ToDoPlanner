//
//  BridgeVCView.swift
//  ToDoPlanner
//
//  Created by Vladyslav Petrenko on 29/09/2024.
//

import SwiftUI

struct BridgeVCView: UIViewControllerRepresentable {
    let viewController = UIViewController()
    typealias UIViewControllerType = UIViewController
    
    func makeUIViewController(context: Context) -> UIViewController {
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}
