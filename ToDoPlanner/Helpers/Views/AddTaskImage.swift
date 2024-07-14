//
//  AddTaskImage.swift
//  ToDoPlanner
//
//  Created by Vladyslav Petrenko on 02/04/2024.
//

import SwiftUI

struct AddTaskImage: View {
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .center) {
                Circle()
                    .trim(from: 0.0, to: 0.55)
                    .fill(.charcoal)
                    .blur(radius: 3)
                    .frame(width: geometry.size.width * 0.95,
                           height: geometry.size.width * 0.95)
                    .rotationEffect(.degrees(-9))
                
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
        }
    }
}

#Preview {
    AddTaskImage()
}
