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
            case categories
        }
    
    @State var selectedTab = Tab.tasks
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                TabView(selection: $selectedTab) {
                    TasksView(viewModel: TasksViewModel())
                        .tabItem {
                            Image(systemName: "list.bullet.clipboard")
                            Text("Tasks")
                        }
                        .tag(Tab.tasks)
                    TasksView(viewModel: TasksViewModel())
                        .tabItem {
                            Image(systemName: "list.bullet")
                            Text("Categories")
                        }
                        .tag(Tab.categories)
                }
                .tint(.white)
                .offset(y: 8)
                .ignoresSafeArea()
                .onAppear {
                    let appearance = UITabBarAppearance()
                    appearance.backgroundEffect = UIBlurEffect(style: .systemChromeMaterial)
                    UITabBar.appearance().standardAppearance = appearance
                    UITabBar.appearance().scrollEdgeAppearance = appearance
                }
                
                AddTaskButton {
                    
                }
                .scaledToFit()
                .frame(width: 60)
                .offset(y: -11.5)
            }
        }
    }
}

#Preview {
    MainView()
}
