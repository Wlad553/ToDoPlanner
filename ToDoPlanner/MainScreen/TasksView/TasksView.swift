//
//  TasksView.swift
//  ToDoPlanner
//
//  Created by Vladyslav Petrenko on 25/02/2024.
//

import SwiftUI
import SwiftData

struct TasksView: View {
    @Bindable var viewModel: TasksParentViewModel
    
    @FocusState var isSearchBarFocused: Bool
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                if viewModel.isSearchBarPresent {
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
                    .listStyle(.insetGrouped)
                    .listRowSpacing(4)
                    .listSectionSpacing(0)
                    .scrollContentBackground(.hidden)
                    .scrollBounceBehavior(viewModel.toDoTasksSorted().isEmpty ? .basedOnSize : .always,
                                          axes: .vertical)
                    .ignoresSafeArea(.keyboard, edges: .all)
                    .scrollDismissesKeyboard(.immediately)
                    .scrollIndicators(.hidden)
                    .padding(.horizontal, -20)
                    
                    Text("All done!")
                        .font(.system(size: 35,
                                      weight: .bold,
                                      design: .rounded))
                        .foregroundStyle(.darkGrayish)
                        .opacity(viewModel.toDoTasksSorted().isEmpty && viewModel.searchText.isEmpty ? 1 : 0)
                    
                    NoSearchResultsView(searchText: viewModel.searchText)
                        .opacity(viewModel.toDoTasksSorted().isEmpty && !viewModel.searchText.isEmpty ? 1 : 0)
                    
                    Color.clear
                        .contentShape(Rectangle())
                        .allowsHitTesting(viewModel.toDoTasksSorted().isEmpty)
                        .padding(.top, 60)
                        .ignoresSafeArea()
                        .gesture(
                            TapGesture().onEnded {
                                isSearchBarFocused = false
                            }, including: viewModel.toDoTasksSorted().isEmpty ? .gesture : .subviews
                        )
                    
                    
                    VStack { // -- Add Task Button
                        Spacer()
                        HStack {
                            Spacer()
                            
                            Button(action: {
                                isSearchBarFocused = false
                                viewModel.isTaskDetailsViewPresented.toggle()
                            }, label: {
                                AddTaskImage()
                            })
                            .scaledToFit()
                            .frame(width: 60)
                            .padding(.bottom, 12)
                            .padding(.trailing, 8)
                        }
                    } // -- Add Task Button
                } // -- ZStack
            } // -- VStack
            .background(.charcoal)
            .onAppear {
                viewModel.refreshToDoTasks()
            }
            .sheet(isPresented: $viewModel.isTaskDetailsViewPresented, content: {
                NavigationStack {
                    TaskDetailsView(viewModel: TaskDetalisViewModel())
                }
            })
        } // -- NavigationStack
    } // -- body
}
