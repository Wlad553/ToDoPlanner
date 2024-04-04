//
//  AddTaskImage.swift
//  ToDoPlanner
//
//  Created by Vladyslav Petrenko on 02/04/2024.
//

import SwiftUI

struct AddTaskButton: View {
    let action: () -> Void
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .center) {
                Circle()
                    .fill(.charcoal)
                    .frame(width: geometry.size.width * 0.88,
                           height: geometry.size.width * 0.88)
                

                
                Button(action: {
                    action()
                }, label: {
                    ZStack(alignment: .center) {
                        Circle()
                            .trim(to: 0.526)
                            .fill(.charcoal)
                            .blur(radius: 3)
                            .frame(width: geometry.size.width * 0.95,
                                   height: geometry.size.width * 0.95)
                        Circle()
                            .fill(.lavenderBliss)
                            .frame(width: geometry.size.width * 0.88,
                                   height: geometry.size.width * 0.88)
                        
                        Image(systemName: "plus")
                            .resizable()
                            .foregroundStyle(.white)
                            .frame(width: geometry.size.width * 0.4,
                                   height: geometry.size.width * 0.4)
                    }
                })
            }
        }
    }
}

#Preview {
    AddTaskButton {}
}
