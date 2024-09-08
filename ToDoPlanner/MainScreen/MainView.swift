//
//  MainView.swift
//  ToDoPlanner
//
//  Created by Vladyslav Petrenko on 04/04/2024.
//

import SwiftUI
import SwiftData

struct MainView: View {
    enum Tab {
            case tasks
            case calendar
        }
        
    @State var selectedTab = Tab.tasks
    @State var isTaskDetailsViewPresented = false
    
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
                    TasksView(isSearchBarPresent: true)
                        .tabItem {
                            Image(systemName: "list.bullet.clipboard")
                            Text("Tasks")
                        }
                        .tag(Tab.tasks)
                    CalendarTasksView()
                        .tabItem {
                            Image(systemName: "calendar")
                            Text("Calendar")
                        }
                        .tag(Tab.calendar)
                } // -- TabView
                .tint(.white)
                .padding(.bottom, hasBottomSafeAreaInset ? -8 : 0)
                .ignoresSafeArea()
                
                Button(action: {
                    isTaskDetailsViewPresented.toggle()
                }, label: {
                    AddTaskImage()
                        .scaledToFit()
                        .frame(width: 60)
                        .offset(y: hasBottomSafeAreaInset ? -8 : -16)
                })
            } // -- ZStack bottom
            .ignoresSafeArea(.keyboard, edges: .all)
            .sheet(isPresented: $isTaskDetailsViewPresented, content: {
                NavigationView {
                    TaskDetailsView()
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
    
    return MainView(selectedTab: .calendar)
        .modelContainer(container)
}
