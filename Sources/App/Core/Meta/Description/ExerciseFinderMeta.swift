//
//  File.swift
//  
//
//  Created by admin on 9/7/23.
//

import Foundation

struct ExerciseFinderMeta: MetaProviderProtocol {
    
    static func getFullDesc(appName: String) -> String {
        let fullDesc21 = "\(appName) is a convenient application for finding exercises. Just enter a query and the app will provide you with a suitable exercise with the name, target muscle group, instructions for performing and difficulty level. Whether you are a beginner or an experienced athlete, \(appName) will help you diversify your workouts, focus on the right muscles and follow the correct technique. With a wide range of exercises and targeted muscle groups, the app will become your reliable assistant in achieving physical goals. Easily find exercises for different body parts and difficulty levels. \(appName) will help you plan and diversify your workouts effectively, making your path to physical fitness more interesting and productive. Take your workouts to the next level with \(appName)!"
        
        let fullDesc1 = "\(appName) is an innovative mobile application designed to help people find and choose the right exercise and training programme. This app provides the user with a wide range of features to help them create a personalised exercise programme, as well as find nearby sports facilities and trainers. \(appName) is your perfect partner for achieving your fitness goals. It is a mobile app that will help you find the perfect workouts that are right for you and will always be there to support and motivate you."

        let fullDesc2 = "One of the main features of \(appName) is its user-friendly and intuitive interface. Users can easily find the right exercises using various filters such as workout type, difficulty level and available equipment. The app also offers personalised recommendations based on the user's preferences and goals. With \(appName), you will no longer get lost in the vast world of fitness and sports. The app offers a wide range of workouts to suit all tastes and fitness levels. Whether you want to burn calories with cardio workouts, build muscle with strength training or learn new sports, \(appName) will help you find the perfect workout to achieve your goals."

        let fullDesc3 = "\(appName) also offers a wide range of workout programmes designed by professional trainers. Users can choose a programme to suit their fitness level and goals. Each programme includes exercise descriptions, video tutorials and progress charts, making workouts more effective and fun. One of the main features of \(appName) is its personalised approach. The app takes into account your preferences, goals and fitness level to offer you the most suitable workouts. You will be able to create your personal profile where you can specify your goals, workout schedule and activity preferences. Based on this data, \(appName) will recommend the most suitable workouts for you and help you develop and achieve new results."

        let fullDesc4 = "One of the key features of \(appName) is the ability to search for nearby sports facilities such as gyms, swimming pools, stadiums and parks. Users can find out the class schedules, prices and services offered by each facility. This allows users to choose the most convenient place to workout and get access to professional equipment and instructors. \(appName) also offers a convenient workout search based on various parameters such as type of workout, difficulty level, duration and available equipment. You will be able to find workouts that match your requirements and preferences. In addition, the app offers detailed descriptions of each workout, video tutorials, and tips from professional trainers to help you exercise correctly and get the most out of each workout."

        let fullDesc5 = "\(appName) also provides the opportunity to connect with personal trainers and get advice on workouts and nutrition. Users can ask questions, share their progress and get support from the workout community. \(appName) is also a great tool for finding sports and fitness events. You can find information about upcoming competitions, marathons, group classes and other sporting events to help you get extra motivated and enjoy an active lifestyle."

        let fullDesc6 = "Progress tracking and goal setting features are also available in the app. Users can record their workouts, measure time, distance and number of repetitions, and then track their progress in graphs and charts. This helps users evaluate their progress and stay motivated. \(appName) also offers the ability to create your own fitness community. You will be able to connect with other users of the app, share your achievements, exchange tips and motivate each other. Be part of an active community that inspires and supports you on your journey to a healthy lifestyle."

        let fullDesc7 = "\(appName) also offers various features to keep your workouts motivated and varied. Users can create their own workouts, share them with other users and participate in Challenges and competitions. This helps create a friendly atmosphere and encourages users to reach new heights. \(appName) is your personal trainer who is always with you. It helps you find the perfect workout, motivates you to achieve new results and supports you on your journey to health and fitness. Don't miss the opportunity to use this amazing app and start your journey to the best version of yourself today!"

        let fullDesc8 = "\(appName) is a useful and convenient app that will help users find suitable exercises and workouts, find the nearest sports facilities and trainers, track their progress and stay motivated. Thanks to its multifunctional features, the app will become an indispensable assistant for everyone who strives for a healthy lifestyle and physical activity. \(appName) is a mobile app that will help you find and choose the right exercises for your workout. Whatever your fitness level or goals, \(appName) will provide you with personalised recommendations and instructions for effective and safe exercise."

        let fullDesc9 = "\(appName) is a mobile app that helps you find and choose the right workouts, sporting events and fitness classes in your city. Regardless of your fitness level or workout preferences, \(appName) provides a wide range of options to help you achieve your fitness goals. One of \(appName)'s main features is to search for exercises by category. You can choose a category that matches your interests and workout goals, such as strength training, cardio, flexibility, or workouts for specific muscle groups. The app will provide you with a list of exercises with detailed descriptions and video tutorials so you can perform each exercise correctly."

        let fullDesc10 = "With \(appName), you can easily find workouts that match your needs and interests. The app offers a variety of workout categories such as cardio, strength training, yoga, Pilates and more. You can choose your workout by difficulty level, duration, or activity type. You can also use filters to find workouts near your location or in a specific area of the city. \(appName) also offers personalised workout recommendations based on your fitness level, goals and available time. You can specify your parameters and the app will create a customised workout programme for you that is effective and suitable for your needs. Each workout will include a variety of exercises so you can develop all aspects of your fitness."

        let fullDesc11 = "\(appName) also provides detailed information about each workout, including descriptions, schedules, instructors and reviews from other users. You can view photos and videos of the workouts to get an idea of the style and atmosphere of the classes. This will help you make an informed choice and select the workout that's right for you. With \(appName), you will also be able to track your progress and achievements. The app will give you the ability to record your workouts including the number of reps, weight, time and other metrics. You will be able to see your progress on graphs and charts, which will help you evaluate your achievements and set yourself up for further improvements."

        let fullDesc12 = "\(appName) offers the possibility to register for sports and fitness events such as marathons, group training or fitness festivals. You can find out about upcoming events, get registration information and purchase tickets directly through the app. It's convenient and time-saving, as you don't have to search for event information from other sources. \(appName) also offers a user community where you can connect with others, share your progress and get support. You will be able to create your own workout groups, enter competitions and share your workout programmes. This will help you stay motivated and get extra support from others who share your interests and goals."

        let fullDesc13 = "\(appName) also offers an activity tracker feature that allows you to track your fitness achievements and progress. You can record your workouts, track time, distance, and number of reps. The app also provides statistics and graphs so you can see your progress over time. It's a great tool for motivation and improving your results. \(appName) also offers additional features such as a workout calendar, workout reminders, a food diary and the ability to connect to other fitness devices and apps. This will allow you to have more control over your workout and achieve better results."

        let fullDesc14 = "\(appName) has a simple and intuitive interface, making it easy to use for all users. You can set up notifications to receive information about new workouts or events that match your preferences. The app also offers the ability to save workouts to your favourites or share them with friends via social media. \(appName) is the perfect app for those who want to get personalised exercise recommendations, track their progress and find support in the community. Whatever your fitness level or goals, \(appName) will help you achieve better results and stay motivated throughout your workout."

        let fullDesc15 = "\(appName) is your trusted assistant in finding and choosing workouts and fitness activities. Whether you want to start exercising, diversify your workout routine or simply find new friends with common interests, \(appName) will help you find what you need. Install the app now and start your journey to better fitness and a healthy lifestyle! \(appName) is your indispensable assistant on your way to fitness goals. It's a mobile app that will help you find the perfect workouts to suit you and will always be there to support and motivate you."

        let fullDesc16 = "\(appName) is your personal trainer and guide in the world of fitness and sports! It is a unique mobile application that helps you find and choose the perfect workouts, sporting events and fitness classes in your city. Whatever your fitness level or workout preferences, \(appName) provides a wide range of options to help you achieve your fitness goals. With \(appName), you will no longer be lost in the vast world of fitness and sports. The app offers a wide range of workouts to suit all tastes and fitness levels. Whether you want to burn calories with cardio, build muscle with strength training or learn new sports, \(appName) will help you find the perfect workout to achieve your goals."

        let fullDesc17 = "With \(appName), you can easily find workouts that match your needs and interests. The app offers a variety of workout categories such as cardio, strength training, yoga, Pilates and more. You can choose your workout by difficulty level, duration, or activity type. You can also use filters to find workouts that are near your location or in a specific area of the city. One of the main features of \(appName) is its personalised approach. The app takes into account your preferences, goals and fitness level to offer you the most suitable workouts. Create your personal profile, specify your goals, workout schedule and activity preferences. Based on this data, \(appName) will recommend the most suitable workouts to help you develop and achieve new results."

        let fullDesc18 = "\(appName) also provides detailed information about each workout, including description, schedule, instructors and reviews from other users. You'll be able to see real photos and videos of the workouts to get an idea of the style and atmosphere of the classes. This will help you make an informed choice and select the workout that's right for you. \(appName) also offers easy workout search by various parameters such as workout type, difficulty level, duration and available equipment. Find workouts that match your requirements and preferences. The app offers detailed descriptions of each workout, video tutorials and tips from professional trainers to help you exercise correctly and get the most out of each workout."

        let fullDesc19 = "\(appName) offers the possibility to register for sports and fitness events such as marathons, group training or fitness festivals. You can find out about upcoming events, get registration information and purchase tickets directly through the app. It's convenient and time-saving, as you don't have to search for event information from other sources. \(appName) is also a great tool for finding sports and fitness events. Find information about upcoming competitions, marathons, group classes and other sporting events to help you get extra motivated and enjoy an active lifestyle."

        let fullDesc20 = "\(appName) also offers an activity tracker feature that allows you to track your fitness achievements and progress. You will be able to record your workouts, track time, distance and number of repetitions. The app also provides statistics and graphs so you can see your progress over time. It's a great tool for motivation and improving your results. \(appName) offers the ability to create your own fitness community. Connect with other users of the app, share your achievements, exchange tips and motivate each other. Be part of an active community that inspires and supports you on your journey to a healthy lifestyle."



        let fullDesc =  [fullDesc1, fullDesc2, fullDesc3, fullDesc4, fullDesc5, fullDesc6, fullDesc7, fullDesc8, fullDesc9, fullDesc10, fullDesc11, fullDesc12, fullDesc13, fullDesc14, fullDesc15, fullDesc16, fullDesc17, fullDesc18, fullDesc19, fullDesc20, fullDesc21]



        return fullDesc.randomElement() ?? fullDesc1
    }
    
    static func getShortDesc(appName: String) -> String {
        let shortDesc21 =  "\(appName): Look for exercises."
        let shortDesc1 =  "\(appName) - your personal trainer is always with you!"

        let shortDesc2 =  "Find the perfect workout with \(appName)!"

        let shortDesc3 =  "\(appName) is your guide to the world of fitness and sport!"

        let shortDesc4 =  "Not sure which workout to choose? \(appName) will help you!"

        let shortDesc5 =  "\(appName) is the best way to reach your fitness goals!"

        let shortDesc6 =  "Find your perfect workout with \(appName)!"

        let shortDesc7 =  "\(appName) is your trusted workout finder!"

        let shortDesc8 =  "Never miss a workout with \(appName)!"

        let shortDesc9 =  "\(appName) is an easy way to find the workout that's right for you!"

        let shortDesc10 = "Start your journey to a healthy lifestyle with \(appName)!"

        let shortDesc11 = "\(appName) is your personal trainer in your pocket!"

        let shortDesc12 = "Find your fitness passion with \(appName)!"

        let shortDesc13 = "\(appName) is the best app to find workouts and sporting events!"

        let shortDesc14 =  "Never get bored in your workouts with \(appName)!"

        let shortDesc15 =  "\(appName) is your perfect fitness travel companion!"

        let shortDesc16 =  "Find new workouts and challenge yourself with \(appName)!"

        let shortDesc17 =  "\(appName) is your guide to the world of fitness news!"

        let shortDesc18 =  "Find your fitness community with \(appName)!"

        let shortDesc19 =  "\(appName) is your personal trainer, available anytime!"

        let shortDesc20 =  " Never rest on your laurels with \(appName)!"

        let shortDesc = [shortDesc1, shortDesc2, shortDesc3, shortDesc4, shortDesc5, shortDesc6, shortDesc7, shortDesc8, shortDesc9, shortDesc10, shortDesc11, shortDesc12, shortDesc13, shortDesc14, shortDesc15, shortDesc16, shortDesc17, shortDesc18, shortDesc19, shortDesc20, shortDesc21]



        return shortDesc.randomElement() ?? shortDesc21
    }
    
    
}
