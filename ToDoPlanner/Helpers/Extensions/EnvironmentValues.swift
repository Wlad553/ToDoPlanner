//
//  EnvironmentValues.swift
//  ToDoPlanner
//
//  Created by Vladyslav Petrenko on 26/05/2024.
//

import SwiftUI

extension EnvironmentValues {
    var orientation: UIInterfaceOrientation {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let orientation = windowScene?.interfaceOrientation ?? .unknown
        
        switch orientation {
        case .portraitUpsideDown, .unknown:
            return .portrait
        default:
            return orientation
        }
    }
}
