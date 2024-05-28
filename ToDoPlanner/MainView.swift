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
    @Environment(\.orientation) var interfaceOrientation
    
    var hasBottomSafeAreaInset: Bool {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let mainWindow = windowScene?.windows.first
        let bottomSafeAreaInset = mainWindow?.safeAreaInsets.bottom ?? 0.0
        return bottomSafeAreaInset != 0
    }
    
    var topSafeAreaInset: CGFloat {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let mainWindow = windowScene?.windows.first
        return mainWindow?.safeAreaInsets.top ?? 0.0
    }
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
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
                    .padding(.bottom, hasBottomSafeAreaInset ? -8 : 0)
                    .ignoresSafeArea()
                    
                    NavigationLink {
                        TaskDetailsView()
                    } label: {
                        AddTaskImage()
                            .scaledToFit()
                            .frame(width: 60)
                            .offset(y: hasBottomSafeAreaInset ? -8 : -16)
                    }
                }
                
                if !topSafeAreaInset.isZero && interfaceOrientation == .portrait {
                    Color.charcoal.opacity(0.97)
                        .frame(height: topSafeAreaInset)
                        .edgesIgnoringSafeArea(.vertical)
                        .blur(radius: 0)
                    Rectangle()
                        .foregroundStyle(.darkGrayish)
                        .frame(height: 0.4)
                        .padding(.top, topSafeAreaInset)
                        .ignoresSafeArea(edges: .vertical)
                        .blur(radius: 0)
                }
            }
        }
        .onAppear {
            let tabBarAppearance = UITabBarAppearance()
            tabBarAppearance.backgroundEffect = UIBlurEffect(style: .systemChromeMaterial)
            UITabBar.appearance().standardAppearance = tabBarAppearance
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        }
    }
}

#Preview {
    MainView()
}
