//
//  NumericDateFormatter.swift
//  ToDoPlanner
//
//  Created by Vladyslav Petrenko on 01/04/2024.
//

import Foundation

final class NumericDateFormatter: DateFormatter {
    override init() {
        super.init()
        self.timeZone = .current
        self.dateStyle = .medium
    }
    
    required init?(coder: NSCoder) {
        assert(false, "init(coder:) must not be used")
        super.init(coder: coder)
    }
}
