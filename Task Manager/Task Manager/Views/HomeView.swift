//
//  HomeView.swift
//  Task Manager
//
//  Created by BS901 on 11/30/22.
//

import SwiftUI

struct HomeView: View {
    @StateObject var taskViewModel: TaskViewModel = .init()
    
    // MARK: Matched Geometry Namespace
    @Namespace var animation
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Welcome Back")
                        .font(.callout)
                    Text("Today's update")
                        .font(.title2.bold())
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical)
                
                customSegmentedBar()
                    .padding(.top, 5)
                
                // MARK: Task View
            }
            .padding()
        }
        .overlay(alignment: .bottom) {
            // MARK: Add Button
            Button {
                taskViewModel.openEditTask.toggle()
            } label: {
                Label {
                    Text("Add Task")
                        .font(.callout)
                        .fontWeight(.semibold)
                } icon: {
                    Image(systemName: "plus.app.fill")
                }
                .foregroundColor(.white)
                .padding(.vertical, 12)
                .padding(.horizontal)
                .background(.black, in: Capsule())
            }
            
            // MARK: Linear Gradient Background
            .padding(.top, 10)
            .frame(maxWidth: .infinity)
            .background {
                LinearGradient(
                    colors: [
                        .white.opacity(0.05),
                        .white.opacity(0.4),
                        .white.opacity(0.7),
                        .white
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
            }
        }
        .fullScreenCover(isPresented: $taskViewModel.openEditTask) {
            taskViewModel.resetTaskData()
        } content: {
            AddTaskView()
                .environmentObject(taskViewModel)
        }
    }
    
    // MARK: Custom Segmented Bar
    @ViewBuilder
    func customSegmentedBar() -> some View {
        let tabs = ["Today", "Upcoming", "Done"]
        
        HStack(spacing: 10) {
            ForEach(tabs, id: \.self) { tab in
                Text(tab)
                    .font(.callout)
                    .fontWeight(.semibold)
                    .scaleEffect(0.9)
                    .foregroundColor(taskViewModel.currentTab == tab ? .white : .black)
                    .padding(.vertical, 6)
                    .frame(maxWidth: .infinity)
                    .background {
                        if taskViewModel.currentTab == tab {
                            Capsule()
                                .fill(.black)
                                .matchedGeometryEffect(id: "TAB", in: animation)
                        }
                    }
                    .contentShape(Capsule())
                    .onTapGesture {
                        withAnimation {
                            taskViewModel.currentTab = tab
                        }
                    }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
