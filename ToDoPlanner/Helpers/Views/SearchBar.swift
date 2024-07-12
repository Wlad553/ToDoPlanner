//
//  SearchBar.swift
//  ToDoPlanner
//
//  Created by Vladyslav Petrenko on 10/07/2024.
//

import SwiftUI

struct SearchBar: View {
    @Binding var searchText: String
    
    private let characterLimit = 50

    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: "magnifyingglass")
            TextField("Find a task", text: $searchText)
                .font(.system(size: 15, weight: .medium))
        }
        .padding(8)
        .background {
            RoundedRectangle(cornerRadius: 15)
                .stroke(lineWidth: 1.5)
                .foregroundStyle(.darkGrayish)
        }
        .onChange(of: searchText) { _, newValue in
            if newValue.count > characterLimit {
                searchText = String(newValue.prefix(characterLimit))
            }
        }
    }
}
