//
//  File.swift
//  
//
//  Created by admin on 30.06.2023.
//

import Foundation

struct RecorderMeta {
    static let fullDesc1 = "When you need to quickly and easily record audio files in any situation, Recorder is your perfect partner. It is a simple and effective recorder application that allows you to record high-quality audio files, save them and share them with others. With Recorder, you can record audio files anytime, and anywhere you have access to your device's microphone. Whether you need to record a lecture, an interview, music or just take a note, Recorder meets all your needs."
    static let fullDesc2 = "One of the best features of Recorder is its ease of use. You can start recording with just one click and then stop recording when you need. The files are automatically saved in mp3 format which ensures high sound quality and minimal file size. Recorder also has many additional features that make it even more convenient and functional. You can use tags to organize your recordings into categories, and add notes to each recording so you won't forget what was recorded. You can also change the playback speed to better understand audio files with fast conversation or, conversely, slow down playback to hear every word."
    static let fullDesc3 = "If you want to share your recordings with others, Recorder makes it easy and convenient to do so. You can send files via email or upload them to cloud storage such as Google Drive or Dropbox. In addition, Recorder also allows you to record continuously, in automatic mode, allowing you to record long events without having to monitor the recording process. You can use the automatic recording feature to record sounds while you sleep, play sports, or even just during a long drive."
    static let fullDesc4 = "If you want to share your recordings with others, Recorder makes it easy and convenient to do so. You can email the files or upload them to cloud storage such as Google Drive or Dropbox. Finally, Recorder also has a beautiful and intuitive interface that makes it easy to use and doesn't distract you from the recording process in any way. You can choose the theme that works best for you to make the app more personal and convenient."
    static let fullDesc5 = "Recorder is a simple and efficient voice recorder application that will help you record high quality sound files in any situation. With its many features and user-friendly interface, Recorder is the perfect tool for anyone who needs to record sound files on a daily basis.You can also change the playback speed to better understand audio files with fast conversation or, conversely, slow down playback to hear every word."
    static let fullDesc6 = "Recorder is a handy and feature-rich voice recorder app that lets you easily create and save audio recordings on your mobile device. Whether you need to record a lecture, an interview, music or just take a note, Recorder provides high quality audio and many additional features for your convenience. One of the main features of Recorder is its intuitive interface, which makes using the application easy and convenient. You can start recording with just one click and then stop recording when you need to. Files are automatically saved in mp3 format, which ensures high sound quality and minimal file size."
    static let fullDesc7 = "It is an application that will help you choose a movie to watch for the evening. With its help you can quickly and easily find a movie that suits your interests and mood. One of the main features of the app is the ability to select a movie according to your mood. You can select the mood that is closest to you, and the app will suggest a list of movies that fit that mood. For example, if you're in the mood for romance, the app will offer you a list of romantic movies. If you're in the mood for adventure, science fiction, or drama, the app will select movies that fit your mood."
    static let fullDesc8 = "One of the best features of Recorder is its ease of use. You can start recording with just one click and then stop recording when you need to. Files are automatically saved in mp3 format, which ensures high sound quality and minimal file size. Recorder also has many additional features that make it even more convenient and functional. It lets you use tags to organize your recordings into categories, and add notes to each recording so you don't forget what was recorded."
    static let fullDesc9 = "If you want to share your recordings with others, Recorder makes it easy and convenient to do so. You can send files via email or upload them to cloud storage such as Google Drive or Dropbox. Recorder also provides the ability to use external microphones to record audio, making it an ideal choice for professionals who want to record high-quality sound files. Recorder also provides the ability to use external microphones to record sound, making it an ideal choice for professionals who want to record high-quality sound files."
    static let fullDesc10 = "Recorder is a simple and efficient voice recorder application that will help you record high quality sound files in any situation. With its many features and user-friendly interface, Recorder is the perfect tool for anyone who needs to record sound files on a daily basis. One of the main advantages of Recorder is its ability to record sounds in the background, which allows you to continue working on your mobile device even if you are recording audio files. This feature also allows you to record phone calls or conversations in Skype or other apps."

    static let shortDesc1 = "Record your thoughts and ideas at any time with Recorder!"
    static let shortDesc2 = "Never miss an important moment with Recorder!"
    static let shortDesc3 = "Record your meetings and conversations with Recorder!"
    static let shortDesc4 = "Recorder is your personal assistant for recording audio!"
    static let shortDesc5 = "Create high-quality audio recordings in any situation with Recorder!"
    static let shortDesc6 = "Recorder is the best way to save the important moments in your life!"
    static let shortDesc7 = "Record voice notes and dictate text with Recorder!"
    static let shortDesc8 = "Never forget important information with Recorder!"
    static let shortDesc9 = "Recorder is your trusted audio recording tool!"
    static let shortDesc10 = "Create your personal audio archive with Recorder!"
    
    static func getFullDesc() -> String {
        let fullDesc = [fullDesc1, fullDesc2, fullDesc3, fullDesc4, fullDesc5, fullDesc6, fullDesc7, fullDesc8, fullDesc9, fullDesc10]
        return fullDesc.randomElement() ?? fullDesc1
    }
    
    static func getShortDesc() -> String {
        let shortDesc = [shortDesc1, shortDesc2, shortDesc3, shortDesc4, shortDesc5, shortDesc6, shortDesc7, shortDesc8, shortDesc9, shortDesc10]
        return shortDesc.randomElement() ?? shortDesc1
    }
}
