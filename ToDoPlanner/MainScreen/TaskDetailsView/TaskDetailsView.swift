//
//  TaskDetailsView.swift
//  ToDoPlanner
//
//  Created by Vladyslav Petrenko on 04/04/2024.
//

import SwiftUI
import SwiftData

struct TaskDetailsView: View {
    enum FocusField: Hashable {
        case titleTextField
        case descriptionTextEditor
    }
    
    @State var viewModel: TaskDetalisViewModel
    
    @State private var keyboardHeight: CGFloat = 0
    @State private var textEditorHeight: CGFloat = 0
    @State private var dueDateOpacity: CGFloat = 1
    @State private var timeOpacity: CGFloat = 1
    
    @State private var keyboardWillShowObserver: NSObjectProtocol?
    @State private var keyboardWillHideObserver: NSObjectProtocol?
    
    @FocusState private var focusField: FocusField?
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            Group {
                TextField("Title", text: $viewModel.draftToDoTask.title)
                    .focused($focusField, equals: .titleTextField)
                    .font(.system(.title3)).fontWeight(.medium)
                    .padding(.top, 12)
                    .padding(.horizontal, 4)
                
                Divider()
                
                GeometryReader { geometry in
                    PlaceholderTextEditor(placeholder: "Description",
                                          text: $viewModel.draftToDoTask.desctiption)
                    .onChange(of: geometry.frame(in: .local)) { oldFrame, newFrame in
                        textEditorHeight = newFrame.height
                    }
                    .focused($focusField, equals: .descriptionTextEditor)
                }
                .font(.system(.subheadline))
                .frame(maxHeight: .infinity)
            } // -- Group
            .onTapGesture {
                timeOpacity = 1
                dueDateOpacity = 1
            }
            
            VStack {
                TaskDetailsCell(text: "Category") {
                    Image(systemName: "list.bullet")
                } rightView: {
                    Menu {
                        Picker(String(), selection: $viewModel.draftToDoTask.category) {
                            ForEach(ToDoTask.Category.allCases.reversed()) { category in
                                Text(category.name)
                                    .tag(category)
                            }
                        }
                    } label: {
                        RoundedContextView(text: viewModel.draftToDoTask.category.name)
                    }
                }
                
                TaskDetailsCell(text: "Due Date") {
                    Image(systemName: "calendar")
                } rightView: {
                    RoundedContextView(text: viewModel.draftToDoTask.dueDate.formatted(date: .abbreviated, time: .omitted))
                        .opacity(dueDateOpacity)
                        .overlay {
                            DatePicker(String(),
                                       selection: $viewModel.draftToDoTask.dueDate,
                                       displayedComponents: .date)
                            .datePickerStyle(.compact)
                            .colorMultiply(.clear)
                            .onTapGesture(count: 99) {
                            }
                            .simultaneousGesture(TapGesture().onEnded {
                                withAnimation {
                                    dueDateOpacity = dueDateOpacity == 1 ? 0.4 : 1.0
                                }
                            })
                        }
                }
                
                TaskDetailsCell(text: "Time") {
                    Image(systemName: "clock")
                } rightView: {
                    RoundedContextView(text: viewModel.draftToDoTask.dueDate.formatted(date: .omitted, time: .shortened))
                        .opacity(timeOpacity)
                        .overlay {
                            DatePicker(String(),
                                       selection: $viewModel.draftToDoTask.dueDate,
                                       displayedComponents: .hourAndMinute)
                            .datePickerStyle(.compact)
                            .colorMultiply(.clear)
                            .onTapGesture(count: 99) {
                            }
                            .simultaneousGesture(TapGesture().onEnded {
                                withAnimation {
                                    timeOpacity = timeOpacity == 1 ? 0.4 : 1.0
                                }
                            })
                        }
                }
                
                TaskDetailsCell(text: "Priority") {
                    Image(viewModel.draftToDoTask.priority.imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 25)
                } rightView: {
                    Menu {
                        Picker(String(), selection: $viewModel.draftToDoTask.priority) {
                            ForEach(ToDoTask.Priority.allCases.sorted()) { priority in
                                HStack {
                                    Image(priority.imageName)
                                    Text(priority.name)
                                }
                                .tag(priority)
                            }
                        }
                    } label: {
                        RoundedContextView(text: viewModel.draftToDoTask.priority.name)
                    }
                }
            } // -- VStack
            .padding(.bottom, keyboardHeight + 64  > textEditorHeight ? -64 : 8)
        } // -- VStack
        .contentShape(Rectangle())
        .onTapGesture {
            focusField = nil
            withAnimation {
                dueDateOpacity = 1
                timeOpacity = 1
            }
        }
        .padding(.horizontal, 8)
        .background(.charcoal)
        .toolbarTitleDisplayMode(.inline)
        .navigationTitle(viewModel.isEditingExistingToDoTask ? String() : "New Task")
        .toolbar {
            if !viewModel.isEditingExistingToDoTask {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        dismiss()
                    }, label: {
                        Image(systemName: "arrow.backward")
                            .foregroundStyle(.white)
                    })
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                HStack {
                    Button {
                        viewModel.deleteEditedToDoTask()
                        dismiss()
                    } label: {
                        Image(systemName: "trash")
                            .tint(.red)
                    }
                    .opacity(viewModel.isEditingExistingToDoTask ? 1.0 : 0.0)
                    
                    Button("Save") {
                        viewModel.saveToDoTask()
                        dismiss()
                    }
                    .disabled(viewModel.draftToDoTask.title.isEmpty)
                }
            }
        }
        .onAppear {
            viewModel.revertDraftToDoTask()
            
            keyboardWillShowObserver = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { notification in
                if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                    guard keyboardHeight < keyboardFrame.height else { return }
                    withAnimation {
                        keyboardHeight = keyboardFrame.height
                    }
                }
            }
            
            keyboardWillHideObserver = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { _ in
                withAnimation {
                    keyboardHeight = 0
                }
            }
        }
        .onDisappear() {
            if let showObserver = keyboardWillShowObserver {
                NotificationCenter.default.removeObserver(showObserver)
            }
            
            if let hideObserver = keyboardWillHideObserver {
                NotificationCenter.default.removeObserver(hideObserver)
            }
            
            keyboardWillShowObserver = nil
            keyboardWillHideObserver = nil
        }
    } // -- body
    
    init(viewModel: TaskDetalisViewModel) {
        self.viewModel = viewModel
    }
}

#Preview {
    TaskDetailsView(viewModel: TaskDetalisViewModel())
}
