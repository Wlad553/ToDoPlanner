//
//  View+addBridge.swift
//  ToDoPlanner
//
//  Created by Vladyslav Petrenko on 29/09/2024.
//

import SwiftUI

extension View {
    func addBridge(_ bridge: BridgeVCView) -> some View {
        self.background(bridge.frame(width: 0, height: 0))
    }
}
