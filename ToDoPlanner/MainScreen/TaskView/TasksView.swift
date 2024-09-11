//
//  TasksView.swift
//  ToDo
//
//  Created by Vladyslav Petrenko on 25/02/2024.
//

import SwiftUI
import SwiftData

struct TasksView: View {
    @Bindable var viewModel: TasksViewModel
    
    @FocusState var isSearchBarFocused: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            if viewModel.isSearchBarPresent {
                SearchBar(searchText: $viewModel.searchText.wrappedValue)
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
                                CategoryView(selectedCategory: $viewModel.selectedCategory.wrappedValue, category: nil)
                                ForEach(ToDoTask.Category.allCases, id: \.self) { category in
                                    CategoryView(selectedCategory: $viewModel.selectedCategory.wrappedValue, category: category)
                                }
                            }
                            .padding(.horizontal, 10)
                        }
                    }
                    .frame(height: 40)
                    .padding(.horizontal, -20)
                    .padding(.top, -6)
                    .padding(.bottom, -8)
                    
                    ForEach(viewModel.toDoTasksSorted(), id: \.key) { section, toDoTasks in
                        Section {
                            ForEach(toDoTasks) { toDoTask in
                                ZStack {
                                    NavigationLink {
                                        TaskDetailsView(viewModel: TaskDetalisViewModel(editedToDoTask: toDoTask))
                                    } label: {
                                        EmptyView()
                                    }
                                    TaskCell(toDoTask: toDoTask)
                                } // -- ZStack
                                .swipeActions {
                                    Button(role: .destructive) {
                                        viewModel.delete(toDoTask: toDoTask)
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
                            ZStack(alignment: .leading) {
                                Text(viewModel.sectionTitle(stringDate: section))
                                    .textCase(.none)
                                    .font(.system(size: 20, weight: .semibold))
                                    .foregroundStyle(.white)
                                    .padding(EdgeInsets(top: -4, leading: 0, bottom: 8, trailing: 0))
                                
                                Color.clear
                                    .contentShape(Rectangle())
                                    .onTapGesture {
                                        isSearchBarFocused = false
                                    }
                            }
                        } // -- Section
                    } // -- ForEach Section
                    .padding(.horizontal, -8)
                } // -- List
                .listStyle(.grouped)
                .listRowSpacing(4)
                .listSectionSpacing(0)
                .scrollContentBackground(.hidden)
                .scrollBounceBehavior(viewModel.toDoTasksSorted().isEmpty ? .basedOnSize : .always,
                                      axes: .vertical)
                .ignoresSafeArea(.keyboard, edges: .all)
                .scrollDismissesKeyboard(.immediately)
                .scrollIndicators(.hidden)
                
                Text("All done!")
                    .font(.system(size: 35,
                                  weight: .bold,
                                  design: .rounded))
                    .foregroundStyle(.darkGrayish)
                    .opacity(viewModel.toDoTasksSorted().isEmpty && viewModel.searchText.wrappedValue.isEmpty ? 1 : 0)
                
                NoSearchResultsView(searchText: viewModel.searchText.wrappedValue)
                    .opacity(viewModel.toDoTasksSorted().isEmpty && !viewModel.searchText.wrappedValue.isEmpty ? 1 : 0)
                
                Color.clear
                    .contentShape(Rectangle())
                    .padding(.top, 60)
                    .ignoresSafeArea()
                    .gesture(
                        TapGesture().onEnded {
                            isSearchBarFocused = false
                        }, including: viewModel.toDoTasksSorted().isEmpty ? .gesture : .subviews
                    )
            } // -- ZStack
        } // -- VStack
        .background(.charcoal)
        .onAppear {
            viewModel.refreshToDoTasks()
        }
    } // -- body
}

#Preview {
    TasksView(viewModel: TasksViewModel(isSearchBarPresent: true, selectedCategory: .constant(nil)))
}
