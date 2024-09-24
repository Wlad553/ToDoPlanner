//
//  MainViewModel.swift
//  ToDoPlanner
//
//  Created by Vladyslav Petrenko on 10/09/2024.
//

import SwiftUI

@Observable
final class MainViewModel: TasksParentViewModel {
    enum Tab {
        case tasks
        case calendar
        case account
    }
    
    var selectedTab: Tab
    
    init(selectedTab: Tab) {
        self.selectedTab = selectedTab
        super.init(isSearchBarPresent: true, selectedDateComponents: DateComponents())
    }
}
