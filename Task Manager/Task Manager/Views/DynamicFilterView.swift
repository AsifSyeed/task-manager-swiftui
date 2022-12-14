//
//  DynamicFilterView.swift
//  Task Manager
//
//  Created by BS901 on 12/2/22.
//

import SwiftUI
import CoreData

struct DynamicFilterView<Content: View, T>: View where T: NSManagedObject {
    // MARK: Core Data request
    
    @FetchRequest var request: FetchedResults<T>
    let content: (T) -> Content
    
    
    // MARK: Custom ForEach for Core Data object to build view
    init(currentTab: String, @ViewBuilder content: @escaping (T) -> Content) {
        
        // MARK: Predicate to filter current date task
        
        let calendar = Calendar.current
        var predicate: NSPredicate!
        
        // Filter key
        let filterKey = "deadline"
        
        if currentTab == "Today" {
            let today = calendar.startOfDay(for: Date())
            let tomorrow = calendar.date(byAdding: .day, value: 1, to: today)!
            predicate = NSPredicate(format: "\(filterKey) >= %@ AND \(filterKey) < %@ AND isCompleted == %i", argumentArray: [today, tomorrow, 0])
        } else if currentTab == "Upcoming" {
            let today = calendar.startOfDay(for: calendar.date(byAdding: .day, value: 1, to: Date())!)
            let tomorrow = Date.distantFuture
            predicate = NSPredicate(format: "\(filterKey) >= %@ AND \(filterKey) < %@ AND isCompleted == %i", argumentArray: [today, tomorrow, 0])
        } else if currentTab == "Failed" {
            let today = calendar.startOfDay(for: Date())
            let past = Date.distantPast
            predicate = NSPredicate(format: "\(filterKey) >= %@ AND \(filterKey) < %@ AND isCompleted == %i", argumentArray: [past, today, 0])
        } else {
            predicate = NSPredicate(format: "isCompleted == %i", argumentArray: [1])
        }
        
        // Initialize request with NSPredicate
        // Adding sort
        _request = FetchRequest(entity: T.entity(), sortDescriptors: [.init(keyPath: \Task.deadline, ascending: false)], predicate: predicate)
        self.content = content
    }
    
    var body: some View {
        Group {
            if request.isEmpty {
                Text("No tasks found")
                    .font(.system(size: 16))
                    .fontWeight(.light)
                    .offset(y: 100)
            } else {
                ForEach(request, id: \.objectID) { object in
                    self.content(object)
                }
            }
        }
    }
}
