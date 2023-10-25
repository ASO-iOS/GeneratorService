//
//  File.swift
//  
//
//  Created by admin on 30.06.2023.
//

import Foundation

struct RecorderMeta: MetaProviderProtocol {
    


    static func getFullDesc(appName: String) -> String {
        let fullDesc1 = "When you need to quickly and easily record audio files in any situation, \(appName) is your perfect partner. It is a simple and effective recorder application that allows you to record high-quality audio files, save them and share them with others. With \(appName), you can record audio files anytime, and anywhere you have access to your device's microphone. Whether you need to record a lecture, an interview, music or just take a note, \(appName) meets all your needs."
        let fullDesc2 = "One of the best features of \(appName) is its ease of use. You can start recording with just one click and then stop recording when you need. The files are automatically saved in mp3 format which ensures high sound quality and minimal file size. \(appName) also has many additional features that make it even more convenient and functional. You can use tags to organize your recordings into categories, and add notes to each recording so you won't forget what was recorded. You can also change the playback speed to better understand audio files with fast conversation or, conversely, slow down playback to hear every word."
        let fullDesc3 = "If you want to share your recordings with others, \(appName) makes it easy and convenient to do so. You can send files via email or upload them to cloud storage such as Google Drive or Dropbox. In addition, \(appName) also allows you to record continuously, in automatic mode, allowing you to record long events without having to monitor the recording process. You can use the automatic recording feature to record sounds while you sleep, play sports, or even just during a long drive."
        let fullDesc4 = "If you want to share your recordings with others, \(appName) makes it easy and convenient to do so. You can email the files or upload them to cloud storage such as Google Drive or Dropbox. Finally, \(appName) also has a beautiful and intuitive interface that makes it easy to use and doesn't distract you from the recording process in any way. You can choose the theme that works best for you to make the app more personal and convenient."
        let fullDesc5 = "\(appName) is a simple and efficient voice recorder application that will help you record high quality sound files in any situation. With its many features and user-friendly interface, \(appName) is the perfect tool for anyone who needs to record sound files on a daily basis.You can also change the playback speed to better understand audio files with fast conversation or, conversely, slow down playback to hear every word."
        let fullDesc6 = "\(appName) is a handy and feature-rich voice recorder app that lets you easily create and save audio recordings on your mobile device. Whether you need to record a lecture, an interview, music or just take a note, \(appName) provides high quality audio and many additional features for your convenience. One of the main features of \(appName) is its intuitive interface, which makes using the application easy and convenient. You can start recording with just one click and then stop recording when you need to. Files are automatically saved in mp3 format, which ensures high sound quality and minimal file size."
        let fullDesc7 = "It is an application that will help you choose a movie to watch for the evening. With its help you can quickly and easily find a movie that suits your interests and mood. One of the main features of the app is the ability to select a movie according to your mood. You can select the mood that is closest to you, and the app will suggest a list of movies that fit that mood. For example, if you're in the mood for romance, the app will offer you a list of romantic movies. If you're in the mood for adventure, science fiction, or drama, the app will select movies that fit your mood."
        let fullDesc8 = "One of the best features of \(appName) is its ease of use. You can start recording with just one click and then stop recording when you need to. Files are automatically saved in mp3 format, which ensures high sound quality and minimal file size. \(appName) also has many additional features that make it even more convenient and functional. It lets you use tags to organize your recordings into categories, and add notes to each recording so you don't forget what was recorded."
        let fullDesc9 = "If you want to share your recordings with others, \(appName) makes it easy and convenient to do so. You can send files via email or upload them to cloud storage such as Google Drive or Dropbox. \(appName) also provides the ability to use external microphones to record audio, making it an ideal choice for professionals who want to record high-quality sound files. \(appName) also provides the ability to use external microphones to record sound, making it an ideal choice for professionals who want to record high-quality sound files."
        let fullDesc10 = "\(appName) is a simple and efficient voice recorder application that will help you record high quality sound files in any situation. With its many features and user-friendly interface, \(appName) is the perfect tool for anyone who needs to record sound files on a daily basis. One of the main advantages of \(appName) is its ability to record sounds in the background, which allows you to continue working on your mobile device even if you are recording audio files. This feature also allows you to record phone calls or conversations in Skype or other apps."

        let fullDesc = [fullDesc1, fullDesc2, fullDesc3, fullDesc4, fullDesc5, fullDesc6, fullDesc7, fullDesc8, fullDesc9, fullDesc10]
        return fullDesc.randomElement() ?? fullDesc1
    }
    
    static func getShortDesc(appName: String) -> String {
        let shortDesc1 = "Record your thoughts and ideas at any time with \(appName)!"
        let shortDesc2 = "Never miss an important moment with \(appName)!"
        let shortDesc3 = "Record your meetings and conversations with \(appName)!"
        let shortDesc4 = "\(appName) is your personal assistant for recording audio!"
        let shortDesc5 = "Create high-quality audio recordings in any situation with \(appName)!"
        let shortDesc6 = "\(appName) is the best way to save the important moments in your life!"
        let shortDesc7 = "Record voice notes and dictate text with \(appName)!"
        let shortDesc8 = "Never forget important information with \(appName)!"
        let shortDesc9 = "\(appName) is your trusted audio recording tool!"
        let shortDesc10 = "Create your personal audio archive with \(appName)!"
        
        let shortDesc = [shortDesc1, shortDesc2, shortDesc3, shortDesc4, shortDesc5, shortDesc6, shortDesc7, shortDesc8, shortDesc9, shortDesc10]
        return shortDesc.randomElement() ?? shortDesc1
    }
}
