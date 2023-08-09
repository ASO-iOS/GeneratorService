//
//  File.swift
//  
//
//  Created by admin on 30.06.2023.
//

import Foundation

struct ToDoListMeta: MetaProviderProtocol {
    static var appName = ""
    static let fullDesc1 = "The \(appName) is an application that helps you organize and organize the tasks that need to be done. It is designed for people who want to be more productive and efficient and who want a more structured approach to managing their time. The basic interface of \(appName) is very simple and intuitive. The user can create new tasks, set priorities and deadlines for them, and mark tasks that have already been completed."
    static let fullDesc2 = "\(appName) is a simple and effective task management application that helps people organize their lives and become more productive. Its intuitive interface and many features make it an ideal choice for those who want to organize their tasks and manage their time more efficiently. In addition, \(appName) also provides the ability to add comments and attachments to tasks so that users can describe their tasks in more detail and share information with colleagues or friends."
    static let fullDesc3 = "\(appName) is an application that helps users organize their tasks and plans for the day, week or month. It is designed for those who want to become more productive and efficient in their work and personal life. The basic interface is very simple and intuitive. The user can create new tasks, set priorities, deadlines and categories for them, and mark tasks that have already been completed. This is especially useful for those who have many tasks and may forget some of them."
    static let fullDesc4 = "\(appName) is a simple and effective task management application that helps people organize their lives and become more productive. Its intuitive interface and many features make it an ideal choice for those who want to organize their tasks and manage their time more efficiently. In addition, the To-Do List also provides the ability to add comments to tasks so that users can describe their tasks in more detail."
    static let fullDesc5 = "Every day we are faced with a lot of tasks to do, and sometimes it can be hard not to forget them. That is why to-do list apps have become an integral part of our daily life. \(appName) is an app that will help you organize your tasks and get them done on time. One of the main features of \(appName) is the creation of tasks. You can easily add a new task just by entering its name and description. You can also set a priority, due date and time, and add tags to make it easier to find the task in the list."
    static let fullDesc6 = "\(appName) also provides the ability to create task lists. For example, you can create a list for work, a list for home tasks, or a list for shopping. This will help you better organize your tasks and not forget about them. Another useful feature of \(appName) is the ability to set reminders. You can set a reminder minutes, hours, or days before the task date. This will help you not to forget about the task and complete it on time."
    static let fullDesc7 = "\(appName) is an easy and convenient way to organize your tasks and get them done on time. With many features and functions, you can easily manage your time and achieve your goals. One of the main features of \(appName) is the creation of tasks. You can easily add a new task by simply entering its name and description. You can also set the priority, date and time of the task, as well as add tags to make it easier to find the task in the list."
    static let fullDesc8 = "When you have a lot of things to do, it can be hard to keep them all in your head. In this case, the \(appName) app can be your trusted assistant. It's an app that helps you manage your tasks and plan your day. With \(appName) you can create tasks, prioritize them, set due dates and add notes. You can view your task list at any time and manage it to achieve your goals."
    static let fullDesc9 = "In the \(appName) app, you can create multiple task lists for different purposes, such as work, personal business, or study. You can easily switch between task lists depending on your current task. Overall, \(appName) is a simple and easy-to-use app to help you organize your day and achieve your goals. You can use it for both personal matters and work, and it will be a reliable assistant in any situation."
    static let fullDesc10 = "When you have a lot of things to do, it can be hard to keep them all in your head. In this case, the \(appName) app can be your reliable assistant. It is an app that helps you manage your tasks and plan your day. In the \(appName) app, you can create multiple task lists for different purposes, such as work, personal business or study. You can easily switch between task lists depending on your current task."

    static let shortDesc1 = "Never forget an important case with the \(appName)!"
    static let shortDesc2 = "Manage your time with \(appName)!"
    static let shortDesc3 = "\(appName) - your reliable assistant in organizing tasks!"
    static let shortDesc4 = "Organize your life with the \(appName)!"
    static let shortDesc5 = "Complete all your tasks on time with the \(appName)!"
    static let shortDesc6 = "\(appName) is the best way to get your day organized!"
    static let shortDesc7 = "\(appName) is an app that will help you achieve your goals!"
    static let shortDesc8 = "Never miss an important thing with \(appName)!"
    static let shortDesc9 = "\(appName) is an easy and convenient way to manage your tasks!"
    static let shortDesc10 = "\(appName) - your personal organizer in your phone!"
    
    static func getFullDesc(appName: String) -> String {
        self.appName = appName
        let fullDesc = [fullDesc1, fullDesc2, fullDesc3, fullDesc4, fullDesc5, fullDesc6, fullDesc7, fullDesc8, fullDesc9, fullDesc10]
        return fullDesc.randomElement() ?? fullDesc1
    }
    
    static func getShortDesc(appName: String) -> String {
        self.appName = appName
        let shortDesc = [shortDesc1, shortDesc2, shortDesc3, shortDesc4, shortDesc5, shortDesc6, shortDesc7, shortDesc8, shortDesc9, shortDesc10]
        return shortDesc.randomElement() ?? shortDesc1
    }
}
