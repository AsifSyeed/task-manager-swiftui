//
//  TaskViewModel.swift
//  Task Manager
//
//  Created by BS901 on 11/30/22.
//

import SwiftUI
import CoreData

class TaskViewModel: ObservableObject {
    @Published var currentTab: String = "Today"
    
    // MARK: New Task Properties
    @Published var openEditTask: Bool = false
    @Published var taskTitle: String = ""
    @Published var taskColor: String = "Yellow"
    @Published var taskDeadline: Date = Date.now
    @Published var taskType: String = "Basic"
    @Published var showDatePicker: Bool = false
    
    // MARK: Editing existing Task
    @Published var editTask: Task?
    
    // MARK: Adding Task to Core Data
    func addTask(context: NSManagedObjectContext) -> Bool {
        
        // MARK: Updating existing data in Core Data
        var task: Task!
        if let editTask = editTask {
            task = editTask
        } else {
            task = Task(context: context)
        }
        
        task.title = taskTitle
        task.color = taskColor
        task.deadline = taskDeadline
        task.type = taskType
        task.isCompleted = false
        
        if let _ = try? context.save() {
            return true
        }
        
        return false
    }
    
    func resetTaskData() {
        taskType = "Basic"
        taskColor = "Yellow"
        taskTitle = ""
        taskDeadline = Date()
    }
    
    // MARK: Edit existing task
    func setupTask() {
        if let editTask = editTask {
            taskType = editTask.type ?? "Basic"
            taskColor = editTask.color ?? "Yellow"
            taskTitle = editTask.title ?? ""
            taskDeadline = editTask.deadline ?? Date()
        }
    }
}
