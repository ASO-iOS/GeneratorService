//
//  File.swift
//  
//
//  Created by admin on 07.07.2023.
//

import Foundation

struct CountdownTimerMeta {
    static let fullDesc1 = "It is an application that allows you to set a specific time and count it back down to zero. The timer can be used for a variety of purposes, such as timing when preparing a meal, setting a time to complete a task, monitoring the duration of an activity, and more. The application has a simple and intuitive interface, making it easy to use for any user."
    static let fullDesc2 = "It is an indispensable tool for those who need accurate time control and planning of their tasks. The timer can be used for various purposes, such as counting down the time when cooking, setting time for tasks and controlling the duration of activities. The app has a simple and intuitive interface, and users can customize the beep and number of repetitions."
    static let fullDesc3 = "It is a mobile app that allows users to set a specific time and count it back down to zero. It can be used for a variety of purposes, such as counting down time when cooking, setting time for tasks and monitoring the duration of activities. The app has a simple and intuitive interface, and users can customize the number of repetitions."
    static let fullDesc4 = "It is an important tool for those who need accurate time control and task scheduling. The countdown timer helps you keep track of the remaining time until important moments in your life. Perfect for birthdays, weddings, and other upcoming, special events"
    static let fullDesc5 = "It an app that allows users to set a specific time and count it back down to zero. This is the best free app for reminding you of anniversaries, your next vacation, trips, friends' birthdays, special moments and more."
    static let fullDesc6 = "Countdown Timer - This is an essential tool for those who need accurate time management and task scheduling. The app can remind you of your birthday countdown, anniversary countdown, vacation countdown, event countdown and appointment countdown, and can also remind you of your various anniversaries such as love anniversary, cat rearing anniversary, growing up anniversary, etc. Allow you to accurately feel the passage of time, better manage and plan the remaining time."
    static let fullDesc7 = "It is a handy app that allows users to set a specific time and count it back down to zero. The app will allow you to count the exact number of days until vacation or vacation. The countdown timer allows you to accurately sense the passage of time and better manage your plans and tasks."
    static let fullDesc8 = "It is an indispensable tool for those who value their time and need accurate time control and task scheduling. The app allows you to set a specific time and count it back down to zero, reminding you of upcoming events such as birthdays, anniversaries, vacations or appointments. In addition, the app can remind you of various anniversaries, such as wedding anniversaries or pet rearing days."
    static let fullDesc9 = "It is a simple and convenient app for setting a specific time and counting it back to zero. It can remind you to count down various events such as birthdays, anniversaries, vacations and appointments. In addition, the app can remind you of various anniversaries, such as wedding anniversaries or relatives' birthdays."
    static let fullDesc10 = "It is an indispensable tool for those who value their time and need accurate time control and scheduling tasks. The countdown timer allows you to accurately sense the passage of time and better manage your plans and tasks, helping you achieve your goals."

    static let shortDesc1 = "A convenient and easy timer in your cell phone!"
    static let shortDesc2 = "A simple and convenient timer in your smartphone!"
    static let shortDesc3 = "A simple and convenient timer in your mobile device!"
    static let shortDesc4 = "A simple and convenient timer on your cell phone!"
    static let shortDesc5 = "Easy to use timer on your mobile device!"
    static let shortDesc6 = "Efficient timer on your mobile device!"
    static let shortDesc7 = "Simple and convenient timer in your cell phone!"
    static let shortDesc8 = "Simple timer in your cell phone!"
    static let shortDesc9 = "A handy timer in your cell phone!"
    static let shortDesc10 = "Efficient timer in your smartphone!"
    
    static func getFullDesc() -> String {
        let fullDesc = [fullDesc1, fullDesc2, fullDesc3, fullDesc4, fullDesc5, fullDesc6, fullDesc7, fullDesc8, fullDesc9, fullDesc10]
        return fullDesc.randomElement() ?? fullDesc1
    }
    
    static func getShortDesc() -> String {
        let shortDesc = [shortDesc1, shortDesc2, shortDesc3, shortDesc4, shortDesc5, shortDesc6, shortDesc7, shortDesc8, shortDesc9, shortDesc10]
        return shortDesc.randomElement() ?? shortDesc1
    }
}
