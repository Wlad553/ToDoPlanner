//
//  TasksView.swift
//  ToDo
//
//  Created by Vladyslav Petrenko on 25/02/2024.
//

import SwiftUI
import SwiftData

struct TasksView: View {
    @Environment(\.modelContext) var context
    @Query private var storedToDoTasks: [ToDoTask]
    
    @State private var viewModel = TasksViewModel()
    @Binding var selectedDateComponents: DateComponents
    
    @FocusState var isSearchBarFocused: Bool
    
    let isSearchBarPresent: Bool
    
    private var isSortedTasksListEmpty: Bool {
        viewModel.sorted(toDoTasksList: storedToDoTasks, selectedDateComponents: selectedDateComponents).isEmpty
    }
    
    var body: some View {
        VStack(spacing: 0) {
            if isSearchBarPresent {
                SearchBar(searchText: $viewModel.searchText)
                    .padding(.horizontal, 10)
                    .frame(height: 56)
                    .focused($isSearchBarFocused)
                Rectangle()
                    .foregroundStyle(.darkGrayish)
                    .frame(height: 0.4)
                    .blur(radius: 0)
            }
            
            ZStack {
                List {
                    Section {
                        EmptyView()
                    } header: {
                        ScrollView(.horizontal) {
                            LazyHStack {
                                CategoryView(selectedCategory: $viewModel.selectedCategory, category: nil)
                                ForEach(ToDoTask.Category.allCases, id: \.self) { category in
                                    CategoryView(selectedCategory: $viewModel.selectedCategory, category: category)
                                }
                            }
                            .padding(.horizontal, 10)
                        }
                    }
                    .frame(height: 40)
                    .padding(.horizontal, -20)
                    .padding(.top, -6)
                    .padding(.bottom, -8)
                    
                    ForEach(viewModel.sorted(toDoTasksList: storedToDoTasks, selectedDateComponents: selectedDateComponents), id: \.key) { section, toDoTasks in
                        Section {
                            ForEach(toDoTasks) { toDoTask in
                                ZStack {
                                    NavigationLink {
                                        TaskDetailsView(editedToDoTask: toDoTask)
                                    } label: {
                                        EmptyView()
                                    }
                                    TaskCell(toDoTask: toDoTask)
                                } // -- ZStack
                                .swipeActions {
                                    Button(role: .destructive) {
                                        viewModel.swiftDataManager.delete(toDoTask: toDoTask)
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                            .tint(.red)
                                    }
                                    Button {
                                        viewModel.toggleIsCompleted(for: toDoTask)
                                    } label: {
                                        Label(toDoTask.isCompleted ? "Unmark\nas Done" : "Mark\nas Done",
                                              systemImage: toDoTask.isCompleted ? "xmark.circle" : "checkmark.circle")
                                        .tint(.purple)
                                    }
                                }
                                .listRowBackground(Color.clear)
                                .listRowSeparator(.hidden)
                            } // -- ForEach Row
                        } header: {
                            Text(viewModel.sectionTitle(stringDate: section))
                                .textCase(.none)
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundStyle(.white)
                                .padding(EdgeInsets(top: -4, leading: 0, bottom: 8, trailing: 0))
                        } // -- Section
                    } // -- ForEach Section
                    .padding(.horizontal, -8)
                } // -- List
                .listStyle(.grouped)
                .listRowSpacing(4)
                .listSectionSpacing(0)
                .scrollContentBackground(.hidden)
                .scrollBounceBehavior(isTaskListEmpty ? .basedOnSize : .always, axes: .vertical)
                .ignoresSafeArea(.keyboard, edges: .all)
                .scrollDismissesKeyboard(.immediately)
                .scrollIndicators(.hidden)
                
                Text("All done!")
                    .font(.system(size: 35,
                                  weight: .bold,
                                  design: .rounded))
                    .foregroundStyle(.darkGrayish)
                    .opacity(isSortedTasksListEmpty && viewModel.searchText.isEmpty ? 1 : 0)
                
                NoSearchResultsView(searchText: viewModel.searchText)
                    .opacity(isSortedTasksListEmpty && !viewModel.searchText.isEmpty ? 1 : 0)
            } // -- ZStack
        } // -- VStack
        .background(.charcoal)
        .onAppear {
            viewModel.swiftDataManager.context = self.context
        }
    } // -- body
    
    init(isSearchBarPresent: Bool = false, selectedDateComponents: Binding<DateComponents> = .constant(DateComponents())) {
        self._selectedDateComponents = selectedDateComponents
        self.isSearchBarPresent = isSearchBarPresent
    }
}

#Preview {
    TasksView(isSearchBarPresent: true)
}
