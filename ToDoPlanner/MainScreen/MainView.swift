//
//  MainView.swift
//  ToDoPlanner
//
//  Created by Vladyslav Petrenko on 04/04/2024.
//

import SwiftUI
import SwiftData

struct MainView: View {
    @State var viewModel = MainViewModel(selectedTab: .tasks)
    
    @Environment(AppState.self) private var appState
    
    private var hasBottomSafeAreaInset: Bool {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let mainWindow = windowScene?.windows.first
        let bottomSafeAreaInset = mainWindow?.safeAreaInsets.bottom ?? 0.0
        return bottomSafeAreaInset != 0
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $viewModel.selectedTab) {
                NavigationStack {
                    TasksView(viewModel: viewModel)
                }
                .tabItem {
                    Image(systemName: "list.bullet.clipboard")
                    Text("Tasks")
                }
                .tag(MainViewModel.Tab.tasks)
                
                NavigationStack {
                    CalendarTasksView()
                }
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Calendar")
                }
                .tag(MainViewModel.Tab.calendar)
                
                AccountView()
                    .tabItem {
                        Image(systemName: "person.fill")
                        Text("Account")
                    }
                    .tag(MainViewModel.Tab.account)
            } // -- TabView
            .tint(.white)
            .padding(.bottom, hasBottomSafeAreaInset ? -8 : 0)
            .ignoresSafeArea()
            
        } // -- ZStack bottom
        .ignoresSafeArea(.keyboard, edges: .all)
        .onAppear {
            let tabBarAppearance = UITabBarAppearance()
            tabBarAppearance.backgroundEffect = UIBlurEffect(style: .systemChromeMaterial)
            UITabBar.appearance().standardAppearance = tabBarAppearance
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        }
        .onChange(of: appState.welcomeViewIsPresented) { _, welcomeViewIsPresented in
            if welcomeViewIsPresented {
                viewModel.selectedTab = .tasks
            }
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: ToDoTask.self, configurations: config)
    
    return MainView(viewModel: MainViewModel(selectedTab: .account))
        .modelContainer(container)
}
