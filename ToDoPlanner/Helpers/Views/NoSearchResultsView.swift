//
//  NoSearchResultsView.swift
//  ToDoPlanner
//
//  Created by Vladyslav Petrenko on 11/07/2024.
//

import SwiftUI

struct NoSearchResultsView: View {
    let searchText: String
    
    var body: some View {
        VStack(alignment: .center, spacing: 14) {
            Image(systemName: "magnifyingglass")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 48)
                .foregroundStyle(.gray)
            
            VStack(alignment: .center) {
                Text("No Results for \"\(searchText)\"")
                    .multilineTextAlignment(.center)
                    .font(.title2).fontWeight(.bold)
                
                Text("Check the spelling or try a new search")
                    .font(.subheadline)
                    .foregroundStyle(.gray)
            }
        }
    }
}

