//
//  File.swift
//  
//
//  Created by admin on 19.07.2023.
//

import Foundation

struct AlarmMeta: MetaProviderProtocol {
    
    
    static func getFullDesc(appName: String) -> String {
        let fullDesc1 = "\(appName) is a mobile application that helps you always be on time. It is a convenient alarm clock that can be set to any time and repeated daily. You can choose any sound for the alarm or use the standard ringtone. The app also has a timer feature that will help you control the time while doing various tasks like cooking or playing sports. You can set the timer for any time and repeat it as needed."
        
        let fullDesc2 = "\(appName) is a simple and reliable app that will help you not to oversleep on important tasks and control your time. It is suitable for both everyday use and for special occasions when you need to be on time. Download Alarm and enjoy its convenience and functionality! In addition, the app has the ability to customize the volume of the beep, allowing you to choose the optimal volume for your alarm clock or timer."
        
        let fullDesc3 = "\(appName) has a simple and intuitive interface that allows you to quickly customize your alarm clock or timer. You can easily control the app and change the settings at any time. In addition, the app has a timer function that will help you control the time when performing various tasks. For example, if you are cooking or exercising, you can set the timer to the right time and control the cooking or exercising process."
        
        let fullDesc4 = "\(appName) is a mobile application that will help you always be on time. It is a convenient alarm clock that can be set for any time and repeated daily. You can choose any sound for the alarm clock or use the standard ringtone. One of the main features of the app is the ability to set the alarm clock for a specific time. You can choose any time you want and set the alarm clock to repeat daily. This way, you won't miss any important event or meeting."
        
        let fullDesc5 = "\(appName) also has the ability to customize the volume of the beep. This allows you to choose the optimal volume for your alarm clock or timer so that you don't oversleep on important matters or miss a call. Another useful feature of the app is the ability to choose a ringtone for your alarm clock or timer. You can choose any sound from the list of available melodies or upload your own melody."
        
        let fullDesc6 = "\(appName) is not only a convenient alarm clock and timer, but also a useful assistant in your daily life.With its help you will always be on time and will not miss any important moment.The application has a wide range of settings that allow you to customize the alarm clock and timer to your needs.You can choose the duration of the beep, set the alarm or timer repetition, and choose the vibration mode for the alarm clock. The alarm clock and timer can be set for different days of the week, allowing you to use the app for everyday tasks or special occasions. For example, if you want to wake up earlier on a weekend day, you can set the alarm for that day only."
        
        let fullDesc7 = "\(appName) also has the ability to create multiple alarms and timers, allowing you to use the app to control the time of multiple tasks at the same time. The app has a simple and intuitive interface that allows you to quickly set up an alarm clock or timer. You can easily manage the app and change the settings at any time."
        
        let fullDesc8 = "Alarm is a simple and reliable application that will help you not to oversleep important tasks and control your time. It is suitable for both everyday use and for special occasions when you need to be on time. Download Alarm and enjoy its convenience and functionality!"
        
        let fullDesc9 = "\(appName) is a mobile application that will help you not to oversleep and always be on time. This app is designed for those who value their time and don't want to be late for important events or meetings. With Alarm, you will be able to set your alarm for the right time and be sure that you will wake up on time. One of the main features of Alarm is the ability to set multiple alarms. You can set multiple alarms for different days of the week or for different times on the same day. This is very convenient for those who have several important things to do or activities to do at different times."
        
        let fullDesc10 = "\(appName) also offers the ability to customize additional alarm settings. For example, you can choose to have the alarm only be active when you plug it in to charge or have it only go off after you complete a certain task, such as solving a math problem or scanning a QR code. One of the main features of Alarm is the ability to set multiple alarms. You can set multiple alarms for different days of the week or for different times on the same day. This is very convenient for those who have several important things to do or activities to do at different times."
        
        let fullDesc11 = "\(appName) is not just an alarm clock app, it is a useful tool for those who want to be always on time and not miss important events. With Alarm you can manage your time and be more productive. Install Alarm today and start managing your time better!Another useful feature of the app is the ability to choose an alarm ringtone.Alarm has a large selection of tunes that will help you wake up awake awake and set you up for a productive day.In addition, you can choose your favorite ringtone or upload your own."
        
        let fullDesc12 = "\(appName) also offers the option to customize the alarm's repetition. You can choose to have the alarm repeat every day, only on weekdays, or only on weekends. This is very convenient for those who have different work or study schedules on different days. Another useful feature of Alarm is the ability to customize the volume of the alarm. You can choose the optimal volume so that you don't oversleep the alarm, but at the same time, you don't wake up your neighbors or family members. You can also choose a gradual volume increase mode to help you wake up more gently and comfortably."
        
        let fullDesc13 = "\(appName) is a mobile app that will help you not oversleep and always be on time. This app is for those who value their time and don't want to be late for important events or appointments. With Alarm, you will be able to set your alarm for the right time and be sure that you will wake up on time. One of the main features of Alarm is the ability to set multiple alarms. You can set multiple alarms for different days of the week or for different times on the same day. This is very convenient for those who have several important things to do or activities to do at different times."
        
        let fullDesc14 = "\(appName) also offers the option to customize the repetition of the alarm. You can choose to have the alarm repeat every day, only on weekdays, or only on weekends. This is very convenient for those who have different work or study schedules on different days. Another useful feature of the app is the ability to choose an alarm ringtone. Alarm has a large selection of melodies that will help you wake up awake awake and set you up for a productive day. You can also choose your favorite tune or upload your own."
        
        let fullDesc15 = "\(appName) also offers the ability to customize additional alarm settings. For example, you can choose to have the alarm be active only when connected to a charger or to have it turn off only after you complete a specific task, such as solving a math problem or scanning a QR code. One of the main features of Alarm is the ability to set multiple alarms. You can set multiple alarms for different days of the week or for different times on the same day. This is very convenient for those who have several important things to do or activities to do at different times."
        
        let fullDesc16 = "\(appName) is not just an alarm clock app, it is a useful tool for those who want to be always on time and not miss important events. With Alarm you can manage your time and be more productive. Install Alarm today and start managing your time better!One of the main problems of modern man is lack of time.We are all busy with work, school, household chores, and other responsibilities, and so it's important to be able to manage your time properly. One way to do this is to use mobile apps that will help you not oversleep and always be on time."
        
        let fullDesc17 = "\(appName) is one such app. With Alarm, you can set your alarm for the right time and make sure you wake up on time. One of the main features of Alarm is the ability to set multiple alarms. You can set multiple alarms for different days of the week or for different times on the same day. This is very convenient for those who have several important things to do or activities to do at different times. Another useful feature of the app is the ability to choose an alarm ringtone. Alarm has a wide selection of tunes that will help you wake up awake awake and set you up for a productive day. In addition, you can choose your favorite ringtone or upload your own."
        
        let fullDesc18 = "\(appName) also offers the option to customize the repetition of the alarm. You can choose to have the alarm repeat every day, only on weekdays, or only on weekends. This is very convenient for those who have different work or study schedules on different days. Another useful feature of Alarm is the ability to customize the volume of the alarm. You can choose the optimal volume so that you don't oversleep the alarm, but at the same time, you don't wake up your neighbors or family members. You can also choose a gradual volume increase mode to help you wake up more gently and comfortably."
        
        let fullDesc19 = "\(appName) also offers the option to customize additional alarm settings. For example, you can choose to have the alarm only be active when connected to a charger or have it only turn off after you complete a specific task, such as solving a math problem or scanning a QR code. One of the advantages of Alarm is its simplicity and ease of use. The app's interface is intuitive and easy to use, making it accessible to all users"
        
        let fullDesc20 = "\(appName) is not just an alarm clock app, it is a useful tool for those who want to be always on time and not miss important events. With Alarm you can manage your time and be more productive. Install Alarm today and start managing your time better! In addition, Alarm does not take up a lot of space on your device and does not load its processor, which allows you to use it on any device."
        let fullDesc = [fullDesc1, fullDesc2, fullDesc3, fullDesc4, fullDesc5, fullDesc6, fullDesc7, fullDesc8, fullDesc9, fullDesc10, fullDesc11, fullDesc12, fullDesc13, fullDesc14, fullDesc15, fullDesc16, fullDesc17, fullDesc18, fullDesc19, fullDesc20]
        
        return fullDesc.randomElement() ?? fullDesc1
        
    }
    
    
    
    static func getShortDesc(appName: String) -> String {
        let shortDesc1 = "Never be late with \(appName)!"
        
        let shortDesc2 = "\(appName) is your reliable time assistant!"
        
        let shortDesc3 = "Manage your time with \(appName)!"
        
        let shortDesc4 = "\(appName) is your personal alarm clock and timer!"
        
        let shortDesc5 = "Never forget important events with \(appName)!"
        
        let shortDesc6 = "\(appName) will help you to always be on time!"
        
        let shortDesc7 = "\(appName) is a simple and easy to use time tracking application!"
        
        let shortDesc8 = "Customize your alarm clock and timer to your needs with \(appName)!"
        
        let shortDesc9 = "\(appName) is a reliable companion in your daily life!"
        
        let shortDesc10 = "With \(appName) you will always be aware of the time!"
        
        let shortDesc11 = "\(appName) is a smart alarm clock and timer in one app!"
        
        let shortDesc12 = "Never oversleep on important tasks with \(appName)!"
        
        let shortDesc13 = "\(appName) is a simple and intuitive interface!"
        
        let shortDesc14 = "Customize your alarm volume and ringtone with \(appName)!"
        
        let shortDesc15 = "\(appName) is an application that will help you control your time!"
        
        let shortDesc16 = "Stay on top of your business with \(appName)!"
        
        let shortDesc17 = "\(appName) is your personal organizer on your mobile device!"
        
        let shortDesc18 = "Never forget important tasks with \(appName)!"
        
        let shortDesc19 = "\(appName) is simple and reliable!"
        
        let shortDesc20 = "Manage your time efficiently with \(appName)!"
        let shortDesc = [shortDesc1, shortDesc2, shortDesc3, shortDesc4, shortDesc5, shortDesc6, shortDesc7, shortDesc8, shortDesc9, shortDesc10, shortDesc11, shortDesc12, shortDesc13, shortDesc14, shortDesc15, shortDesc16, shortDesc17, shortDesc18, shortDesc19, shortDesc20]
        
        return shortDesc.randomElement() ?? shortDesc1
        
    }
}
