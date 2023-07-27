//
//  File.swift
//  
//
//  Created by admin on 07.07.2023.
//

import Foundation

struct EventsMeta {
    static var appName = ""
    static let fullDesc1 = "The \(appName) is a handy tool for managing tasks and planning your time. Here you can create and keep track of various tasks, meetings, events, holidays, and plan your schedule for a week, month, or year ahead. Clear and visually appealing interface allows you to quickly and conveniently customize the application to your needs and ease of use."
    static let fullDesc2 = "The \(appName) is a reliable assistant in planning the schedule for each day. It provides the ability to create numerous events, set reminders, customize dates and times, and set up notifications so you never miss important things. The app features reminders, notifications, and synchronization with other devices, so you can always be aware of your plans and never miss important meetings and events."
    static let fullDesc3 = "The calendar has a simple and intuitive interface that is easy to use and easy to customize. Whether it's professional or personal events, the \(appName) ensures that you're always on top of your schedule, ready to go, and won't forget important events in your life."
    static let fullDesc4 = "The \(appName) is a handy tool for planning and organizing your daily life. It lets you create events, set reminders, add notes, and keep track of your schedule of days. Easy to manage and customize, \(appName) will help you not miss any important appointments or events."
    static let fullDesc5 = "\(appName) is a mobile app that will help you manage your time and keep track of important dates and events. With its help, you will be able to create and save reminders about meetings, tasks, birthdays and other events, as well as keep track of your schedule. The application has a simple and user-friendly interface that allows you to quickly and easily create new entries in your calendar."
    static let fullDesc6 = "The calendar allows you to set up recurring reminders - daily, weekly, monthly, etc. In this way, you can be sure that no important event will pass your attention. The app also provides a simple visualization of your schedule for a particular day or week. This helps you plan your things better and encourages a proactive approach to planning."
    static let fullDesc7 = "\(appName) is a useful, super convenient app that lets you keep all your important dates and events in one place. The main features of the calendar make it stand out among similar apps. For example, you can highlight the ease of use and high speed of operation, the absence of advertising in the application."
    static let fullDesc8 = "\(appName) is an effective tool for planning and organizing your time. With its user-friendly and intuitive interface, the user can create events, appointments, reminders and tasks, as well as keep track of due dates for assigned tasks and appointments."
    static let fullDesc9 = "\(appName) are displayed conveniently on the graphical interface, making it easier for the user to schedule time and not miss important appointments. \(appName) provides an ideal solution for those who want to manage their time more efficiently, while getting maximum convenience and functionality from a single application."
    static let fullDesc10 = "\(appName) is one of the most important applications for any device. It allows us to plan our life and time to be more organized. The \(appName) is one of the most popular calendars today, and this is no accident. With this app, you can easily and quickly create and manage your events and reminders."

    static let shortDesc1 = "A handy calendar in your cell phone!"
    static let shortDesc2 = "A simple calendar in your smartphone!"
    static let shortDesc3 = "A simple and handy calendar in your mobile device!"
    static let shortDesc4 = "A simple and convenient calendar on your cell phone!"
    static let shortDesc5 = "Easy to use calendar on your mobile device!"
    static let shortDesc6 = "Efficient calendar on your mobile device!"
    static let shortDesc7 = "Simple and convenient calendar in your cell phone!"
    static let shortDesc8 = "Simple calendar in your cell phone!"
    static let shortDesc9 = "A handy calendar in your cell phone!"
    static let shortDesc10 = "Efficient calendar in your smartphone!"
    
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
