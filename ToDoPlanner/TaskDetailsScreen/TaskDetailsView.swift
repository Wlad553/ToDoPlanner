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
    
    enum TaskCategory: String, Hashable, CaseIterable, Identifiable, Comparable {
        static func < (lhs: TaskDetailsView.TaskCategory, rhs: TaskDetailsView.TaskCategory) -> Bool {
            lhs.rawValue > rhs.rawValue
        }
        
        var id: String {
            rawValue
        }
        
        case home = "Home"
        case work = "Work"
    }
        
    @State private var titleText: String = String()
    @State private var descriptionText: String = String()
    
    @State private var taskCategory: TaskCategory = .home
    
    @State private var keyboardHeight: CGFloat = 0
    @State private var textEditorHeight: CGFloat = 0
    @State private var isTextEditorFrameOnceChanged = false
    
    @FocusState private var focusField: FocusField?

    var body: some View {
        VStack {
            Group {
                TextField("Title", text: $titleText)
                    .focused($focusField, equals: .titleTextField)
                    .font(.system(.headline))
                    .padding(.top, 12)
                
                Divider()
                
                GeometryReader { geometry in
                    PlaceholderTextEditor(placeholder: "Description",
                                          text: $descriptionText)
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
                .border(.gray, width: 2)
            }
            .onTapGesture {}
            
            LazyVStack {
                TaskDetailsCell(text: "Category") {
                    Image(systemName: "list.bullet")
                } rightView: {
                    Menu {
                        Picker(String(), selection: $taskCategory) {
                            ForEach(TaskCategory.allCases.sorted()) { category in
                                Text(category.rawValue)
                                    .tag(category)
                            }
                        }
                    } label: {
                        RoundedContextView(text: taskCategory.rawValue)
                    }
                }
                
                TaskDetailsCell(text: "Due Date") {
                    Image(systemName: "calendar")
                } rightView: {
                    EmptyView()
                }
                
                TaskDetailsCell(text: "Time") {
                    Image(systemName: "clock")
                } rightView: {
                    EmptyView()
                }
                
                TaskDetailsCell(text: "Priority") {
                    Image("lowPriority")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 25)
                } rightView: {
                    EmptyView()
                }
            }
            .padding(.bottom, keyboardHeight + 80  > textEditorHeight ? -64 : 8)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            focusField = nil
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
    }
}

#Preview {
    TaskDetailsView()
}
