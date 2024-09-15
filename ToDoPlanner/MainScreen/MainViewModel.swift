//
//  MainViewModel.swift
//  ToDoPlanner
//
//  Created by Vladyslav Petrenko on 10/09/2024.
//

import SwiftUI

@Observable
final class MainViewModel {
    enum Tab {
        case tasks
        case calendar
        case account
    }
    
    var selectedTab: Tab
    var isTaskDetailsViewPresented = false
    
    var searchText = String()
    var selectedCategory: ToDoTask.Category?
    
    init(selectedTab: Tab) {
        self.selectedTab = selectedTab
    }
}
