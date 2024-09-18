//
//  MainView.swift
//  ToDoPlanner
//
//  Created by Vladyslav Petrenko on 04/04/2024.
//

import SwiftUI
import SwiftData

struct MainView: View {
    @State var viewModel: MainViewModel
    
    private var hasBottomSafeAreaInset: Bool {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let mainWindow = windowScene?.windows.first
        let bottomSafeAreaInset = mainWindow?.safeAreaInsets.bottom ?? 0.0
        return bottomSafeAreaInset != 0
    }
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                TabView(selection: $viewModel.selectedTab) {
                    TasksView(viewModel: TasksViewModel(isSearchBarPresent: true,
                                                        searchText: $viewModel.searchText,
                                                        selectedCategory: $viewModel.selectedCategory))
                        .tabItem {
                            Image(systemName: "list.bullet.clipboard")
                            Text("Tasks")
                        }
                        .tag(MainViewModel.Tab.tasks)
                    CalendarTasksView()
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
                
                HStack(alignment: .bottom) {
                    Spacer()
                    
                    Button(action: {
                        viewModel.isTaskDetailsViewPresented.toggle()
                    }, label: {
                        AddTaskImage()
                    })
                    .scaledToFit()
                    .frame(width: 60)
                    .padding(.bottom, hasBottomSafeAreaInset ? 52 : 60)
                    .padding(.trailing, 8)
                }
                .opacity(viewModel.selectedTab == .account ? 0.0 : 1.0)
            } // -- ZStack bottom
            .ignoresSafeArea(.keyboard, edges: .all)
            .sheet(isPresented: $viewModel.isTaskDetailsViewPresented, content: {
                NavigationStack {
                    TaskDetailsView(viewModel: TaskDetalisViewModel())
                }
            })
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
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: ToDoTask.self, configurations: config)
    
    return MainView(viewModel: MainViewModel(selectedTab: .calendar))
        .modelContainer(container)
}
