//
//  MainView.swift
//  ToDoPlanner
//
//  Created by Vladyslav Petrenko on 04/04/2024.
//

import SwiftUI

struct MainView: View {
    enum Tab {
            case tasks
            case calendar
        }
    
    @State private var viewModel: MainViewModel = MainViewModel()
    
    @State var selectedTab = Tab.tasks
    @Environment(\.orientation) private var interfaceOrientation
    
    private var hasBottomSafeAreaInset: Bool {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let mainWindow = windowScene?.windows.first
        let bottomSafeAreaInset = mainWindow?.safeAreaInsets.bottom ?? 0.0
        return bottomSafeAreaInset != 0
    }
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                TabView(selection: $selectedTab) {
                    TasksView(isSearchBarPresent: true, toDoTasksList: $viewModel.toDoTasks)
                        .tabItem {
                            Image(systemName: "list.bullet.clipboard")
                            Text("Tasks")
                        }
                        .tag(Tab.tasks)
                    CalendarTasksView(toDoTasksList: $viewModel.toDoTasks)
                        .tabItem {
                            Image(systemName: "calendar")
                            Text("Calendar")
                        }
                        .tag(Tab.calendar)
                } // -- TabView
                .tint(.white)
                .padding(.bottom, hasBottomSafeAreaInset ? -8 : 0)
                .ignoresSafeArea()
                
                NavigationLink {
                    TaskDetailsView(toDoTasksList: $viewModel.toDoTasks)
                } label: {
                    AddTaskImage()
                        .scaledToFit()
                        .frame(width: 60)
                        .offset(y: hasBottomSafeAreaInset ? -8 : -16)
                }
            } // -- ZStack bottom
            .ignoresSafeArea(.keyboard, edges: .all)
        } // -- NavigationStack
        .onAppear {
            let tabBarAppearance = UITabBarAppearance()
            tabBarAppearance.backgroundEffect = UIBlurEffect(style: .systemChromeMaterial)
            UITabBar.appearance().standardAppearance = tabBarAppearance
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        }
    }
}

#Preview {
    MainView(selectedTab: .calendar)
}
