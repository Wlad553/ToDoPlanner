//
//  TaskDetailsView.swift
//  ToDoPlanner
//
//  Created by Vladyslav Petrenko on 04/04/2024.
//

import SwiftUI

struct TaskDetailsView: View {
    enum FocusField: Hashable {
        case titleTextField
        case descriptionTextEditor
    }
    
    @State private var toDoTask: ToDoTask = ToDoTask()
    
    @State private var keyboardHeight: CGFloat = 0
    @State private var textEditorHeight: CGFloat = 0
    @State private var isTextEditorFrameOnceChanged = false
    @State private var dueDateOpacity: CGFloat = 1
    @State private var timeOpacity: CGFloat = 1
    
    @FocusState private var focusField: FocusField?

    var body: some View {
        VStack {
            Group {
                TextField("Title", text: $toDoTask.title)
                    .focused($focusField, equals: .titleTextField)
                    .font(.system(.headline))
                    .padding(.top, 12)
                
                Divider()
                
                GeometryReader { geometry in
                    PlaceholderTextEditor(placeholder: "Description",
                                          text: $toDoTask.desctiption)
                    .onChange(of: geometry.frame(in: .local)) { oldFrame, newFrame in
                        guard oldFrame.height != newFrame.height && isTextEditorFrameOnceChanged else {
                            isTextEditorFrameOnceChanged = true
                            return
                        }
                        textEditorHeight = newFrame.height
                    }
                    .focused($focusField, equals: .descriptionTextEditor)
                }
                .font(.system(.subheadline))
                .frame(minHeight: 64, maxHeight: .infinity)
            } // -- Group
            .onTapGesture {
                timeOpacity = 1
                dueDateOpacity = 1
            }
            
            LazyVStack {
                TaskDetailsCell(text: "Category") {
                    Image(systemName: "list.bullet")
                } rightView: {
                    Menu {
                        Picker(String(), selection: $toDoTask.category) {
                            ForEach(ToDoTask.Category.allCases.sorted()) { category in
                                Text(category.name)
                                    .tag(category)
                            }
                        }
                    } label: {
                        RoundedContextView(text: toDoTask.category.rawValue)
                    }
                }
                
                TaskDetailsCell(text: "Due Date") {
                    Image(systemName: "calendar")
                } rightView: {
                    RoundedContextView(text: toDoTask.dueDate.formatted(date: .abbreviated, time: .omitted))
                        .opacity(dueDateOpacity)
                        .overlay {
                            DatePicker(String(),
                                       selection: $toDoTask.dueDate,
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
                    RoundedContextView(text: toDoTask.dueDate.formatted(date: .omitted, time: .shortened))
                        .opacity(timeOpacity)
                        .overlay {
                            DatePicker(String(),
                                       selection: $toDoTask.dueDate,
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
                    Image(toDoTask.priority.imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 25)
                } rightView: {
                    Menu {
                        Picker(String(), selection: $toDoTask.priority) {
                            ForEach(ToDoTask.Priority.allCases.sorted()) { priority in
                                HStack {
                                    Image(priority.imageName)
                                    Text(priority.name)
                                }
                                .tag(priority)
                            }
                        }
                    } label: {
                        RoundedContextView(text: toDoTask.priority.name)
                    }
                }
            } // -- LazyVStack
            .padding(.bottom, keyboardHeight + 80  > textEditorHeight ? -64 : 8)
        } // -- VStack
        .contentShape(Rectangle())
        .onTapGesture {
            focusField = nil
            withAnimation {
                dueDateOpacity = 1
                timeOpacity = 1
            }
        }
        .background {
            GeometryReader { geometry in
                Color.clear
                    .onAppear {
                        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { notification in
                            if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                                guard keyboardHeight < keyboardFrame.height else { return }
                                withAnimation {
                                    keyboardHeight = keyboardFrame.height + geometry.safeAreaInsets.bottom
                                }
                            }
                        }
                        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { _ in
                            withAnimation {
                                keyboardHeight = 0
                            }
                        }
                    }
            }
        }
        .padding(.horizontal, 8)
    } // -- body
}

#Preview {
    TaskDetailsView()
}
