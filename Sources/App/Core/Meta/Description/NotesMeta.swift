//
//  File.swift
//  
//
//  Created by admin on 07.07.2023.
//

import Foundation

struct NotesMeta: MetaProviderProtocol {
    

    
    static func getFullDesc(appName: String) -> String {
        let fullDesc1 = "\(appName) is an innovative mobile application designed to improve and optimize the writing process on smartphones and tablets. With this app, users can significantly improve their efficiency and productivity when writing texts, be it emails, messenger messages, notes or documents. Another useful feature of the app is the correction of typos and errors. \(appName) automatically detects and highlights errors in the user's text, suggesting the correct options. The user can simply tap on the word with the error and select the correct correction from the list of suggested options. This helps to avoid typos and improves the quality of the written text."

        let fullDesc2 = "One of the main features of \(appName) is its intuitive and easy-to-use interface. Users can easily navigate through the application thanks to its easy navigation and clear icons. Thanks to this, even beginners will be able to quickly learn all the features of the application. \(appName) also offers a wide range of thematic dictionaries and specialized databases. For example, the user can choose a dictionary for business correspondence, academic writing, technical documentation and other areas. Each dictionary contains specific terms and phrases, which helps the user to write texts relevant to the particular field."

        let fullDesc3 = "One of the main functions of \(appName) is auto-completion of text. The application has an extensive database of words and phrases that are used in everyday communication. When the user starts typing a word or phrase, \(appName) offers auto-complete options based on the context and previous inputs. This greatly speeds up the writing process as the user can select the desired word or phrase with a single tap. Another useful feature of \(appName) is the ability to create and save text templates. The user can create and save standard phrases that are frequently used in advance so that they don't waste time re-typing them. This is especially useful when writing formal letters or documents where the same phrases are often used."

        let fullDesc4 = "Another useful feature of the application is the correction of typos and errors. \(appName) automatically detects and highlights errors in the user's text and suggests the correct options. The user can simply tap on the word with the error and select the correct correction from the list of suggested options. This helps to avoid typos and improves the quality of the written text. \(appName) also supports synchronization with cloud services such as Google Drive or Dropbox. This allows users to save their texts in the cloud and access them from any device. In addition, \(appName) offers an automatic backup feature so that users don't lose their data if their device crashes."

        let fullDesc5 = "\(appName) also offers a wide range of subject-specific dictionaries and specialized databases. For example, users can choose a dictionary for business correspondence, academic writing, technical documentation, etc. Each dictionary contains specific terms and phrases, which helps the user to write texts relevant to a particular field. \(appName) app also offers customization and personalization features. Users can choose different design themes, fonts, and text sizes to customize the app to their preferences. Additionally, users can add their own words and phrases to the app's database for more accurate auto-completion."

        let fullDesc6 = "Another useful feature of \(appName) is the ability to create and save text templates. Users can create and save standard phrases that they use frequently in advance so that they don't have to waste time re-typing them. This is especially useful when writing formal letters or documents that frequently use the same phrases. \(appName) is a powerful tool for anyone who needs to write texts efficiently and quickly on mobile devices. With its auto-complete, error correction, specialized dictionaries and other features, users can save time and improve the quality of their text messages. \(appName) is an indispensable assistant for anyone who values their time and strives for professionalism in written communication."

        let fullDesc7 = "\(appName) also supports synchronization with cloud services such as Google Drive or Dropbox. This allows users to save their texts in the cloud and access them from any device. In addition, \(appName) offers an automatic backup feature so that users don't lose their data if their device crashes. \(appName) is an innovative mobile app designed to meet users' needs for fast and efficient writing on smartphones and tablets. It offers a number of unique features and tools that significantly improve the typing process and increase user productivity."

        let fullDesc8 = "SThe \(appName) app also offers customization and personalization features. Users can select different design themes, fonts, and text sizes to customize the app to their preferences. Additionally, users can add their own words and phrases to the app's database for more accurate auto-completion. One of \(appName)'s key features is its advanced predictive text input system. This feature allows the app to predict the next word or phrase the user is about to write. Thanks to this, the user can write texts much faster as they don't have to type complete words or sentences every time. \(appName) analyzes the context and previously entered data to suggest the most likely variants of the next words or phrases. Thus, the user can write texts quickly and effortlessly."

        let fullDesc9 = "\(appName) is a powerful tool for anyone who needs efficient and fast texting on mobile devices. Thanks to its auto-complete, error correction, specialized dictionaries and other features, users can save time and improve the quality of their text messages. \(appName) is an indispensable assistant for anyone who values their time and strives for professionalism in written communication. \(appName) also offers a wide range of customizable interface design themes. This allows each user to choose the right style for him or her and create a comfortable working environment. From bright and colorful themes to more subdued and professional options, \(appName) caters to all tastes."

        let fullDesc10 = "\(appName) is an innovative mobile application designed to improve and speed up the writing process on smartphones and tablets. With this app, users will be able to write texts faster and more efficiently thanks to its user-friendly interface, intuitive features and automation tools. In addition to predictive text input, \(appName) offers other useful features to help improve the writing process. For example, the app has a built-in auto-replacement dictionary that automatically corrects typos and errors. This is especially useful for users who write on large screens on smartphones or tablets, where the likelihood of typos is higher. \(appName) also offers an auto-complete feature that suggests word or phrase continuation options based on context and previously entered data. This helps save time and reduce writing errors."
        let fullDesc11 = "One of the main features of \(appName) is its unique predictive text input system, which predicts the next word or phrase the user is about to write. This significantly reduces the time spent typing, as the user does not have to type the full word or sentence each time. The application analyzes the previously entered data and context to suggest the most likely next word or phrase. Thus, the user can text quickly and effortlessly. Another useful feature of \(appName) is the ability to create custom templates for frequently used phrases or texts. The user can create and save their own templates to quickly insert them into texts without having to type the same phrases each time. This is especially useful for those who often send the same type of messages or have a particular writing style."

        let fullDesc12 = "\(appName) also offers a wide range of customizable interface design themes so that each user can choose the right style for them. This allows for a comfortable working environment and increases user satisfaction. \(appName) also offers cross-device data synchronization, which allows users to work on texts on different devices without having to copy and paste texts. All data is stored in the cloud and the user can easily access it from any device on which the application is installed. \(appName) also supports voice recognition, which allows users to dictate texts instead of typing. This is especially useful for those who prefer speaking over writing, or for cases where typing is inconvenient or impossible."

        let fullDesc13 = "In addition to predictive text input, \(appName) also offers other useful features to help improve your writing process. For example, the app has a built-in auto-replacement dictionary that automatically corrects typos and errors. This is especially useful for those who write on large screens on smartphones or tablets, where typos are more likely to occur. \(appName) also offers an auto-complete feature that suggests word or phrase continuation options based on previously entered data and context. This helps save time and reduce writing errors. \(appName) is a powerful and intuitive application that greatly simplifies and speeds up the writing process on mobile devices. Thanks to its functionality and usability, users will be able to text faster and more efficiently, saving time and effort. Whether you need to write a short message or a long article, \(appName) will be your reliable assistant in creating high-quality texts."

        let fullDesc14 = "Another useful feature of \(appName) is the ability to create custom templates for frequently used phrases or texts. Users can create and save their own templates to quickly insert them into texts without having to type the same phrases each time. This is especially useful for those who often send the same type of messages or have a particular writing style. \(appName) is an innovative mobile app designed to optimize and improve the writing process on smartphones and tablets. It is a revolutionary solution that allows users to significantly increase efficiency and productivity when writing text messages, emails, notes and documents."

        let fullDesc15 = "\(appName) also offers the ability to synchronize data between devices, allowing users to work on texts on different devices without having to copy and paste texts. All data is stored in the cloud and the user can easily access it from any device with the app installed. One of the key features of \(appName) is its simple and intuitive interface. Users can easily navigate through the app thanks to the user-friendly navigation and clear icons. Even beginners will be able to quickly learn all the features of the application. One of the main features of \(appName) is the auto-completion of text. The application has an extensive database of words and phrases used in everyday communication. When the user starts typing a word or phrase, \(appName) suggests auto-completion options based on the context and previous inputs. This greatly speeds up the writing process as the user can select the desired word or phrase with a single click."

        let fullDesc16 = "\(appName) supports voice recognition, allowing users to dictate texts instead of typing. This is especially useful for those who prefer speaking to writing, or for when typing is inconvenient or impossible. Another useful feature of the app is the correction of typos and errors. \(appName) automatically detects and highlights errors in the user's text, suggesting the correct options. The user can simply tap on the word with the error and select the correct correction from the list of suggested options. This helps to avoid typos and improves the quality of the written text."

        let fullDesc17 = "\(appName) is a powerful and intuitive application that greatly simplifies and speeds up the writing process on mobile devices. Thanks to its functionality and usability, users will be able to write texts faster and more efficiently, saving time and effort. Whether you need to write a short message or a long article, \(appName) will be your reliable assistant in creating high-quality texts. \(appName) also offers a wide range of subject-specific dictionaries and specialized databases. For example, the user can choose a dictionary for business correspondence, academic writing, technical documentation and other areas. Each dictionary contains specific terms and phrases, which helps the user to write texts appropriate for a particular field."

        let fullDesc18 = "\(appName) is a revolutionary mobile application designed to optimize and improve the writing process on smartphones and tablets. It is an innovative solution that will help users significantly increase efficiency and productivity when writing text messages, emails, notes and documents. Another useful feature of \(appName) is the ability to create and save text templates. Users can pre-create and save standard phrases that are frequently used so that they don't have to waste time re-typing them. This is especially useful when writing formal letters or documents that frequently use the same phrases."

        let fullDesc19 = "One of the key features of \(appName) is its simple and intuitive interface. Users can easily navigate through the application thanks to the user-friendly navigation and clear icons. Even beginners will be able to quickly learn all the features of the application. \(appName) also supports synchronization with cloud services such as Google Drive or Dropbox. This allows users to save their texts in the cloud and access them from any device. In addition, \(appName) offers an automatic backup feature so that users don't lose their data if their device crashes."

        let fullDesc20 = "One of the main functions of \(appName) is auto-completion of text. The application has an extensive database of words and phrases used in everyday communication. When the user starts typing a word or phrase, \(appName) suggests autocomplete options based on the context and previous inputs. This greatly speeds up the writing process as the user can select the desired word or phrase with a single tap. The \(appName) app also offers customization and personalization features. Users can choose different design themes, fonts, and text sizes to customize the app to their preferences. Additionally, users can add their own words and phrases to the app's database for more accurate auto-completion."
        let fullDesc21 = "\(appName) is a simple notepad. It allows you to take notes, reminders, emails, messages, to-do lists, and shopping lists easily and easily. \(appName) is easier to create notes than any other notebook or organizer. This application allows you to create notes quickly and easily, making it an indispensable tool for various tasks."
        let fullDesc22 = "\(appName) is a handy note taking application that will help you organize your life and not forget important moments. It is a simple notepad that allows you to quickly and easily write notes, reminders, emails, messages, to-do lists and shopping. All the controls are in one screen, which makes working with the application as convenient and efficient as possible."
        let fullDesc23 = "If you are looking for a simple and convenient way to organize your life and not to forget important moments, \(appName) is a great choice for you. It provides fast and accurate note taking, a high level of security and a simple interface, making it the perfect choice for users of all levels. Whether you are a professional developer or just want to organize your life, \(appName) will help you achieve that goal."
        let fullDesc24 = "\(appName) can be used for both personal and professional purposes. One of the main features of Note is its simple and intuitive interface. You can easily get used to its functionality even if you have had no previous experience with similar applications. All the controls are located on one screen, which makes working with the application as convenient and efficient as possible."
        let fullDesc25 = "\(appName) can be used to create notes, reminders, emails, messages, to-do lists and shopping. The application also has a number of additional features that make it even more convenient and functional. You can easily customize the color of your notes to quickly and easily distinguish them. In addition, the app supports multiple languages, allowing you to choose the best option for your particular task."
        let fullDesc26 = "\(appName) is an application that will be an indispensable assistant in organizing your life. With it you can create notes on any topic, from shopping to important business meetings. \(appName) is a handy notebook that allows you to quickly and easily write down everything you need."
        let fullDesc27 = "\(appName) can be used for both personal and professional purposes. It can be used to create notes, reminders, emails, messages, to-do lists and shopping. The application allows you to create notes quickly and easily, making it an indispensable tool for various tasks."
        let fullDesc28 = "If you are looking for an easy and convenient way to organize your life and not to forget important moments, \(appName) is a great choice for you. It provides fast and accurate note taking, a high level of security and a simple interface, making it an ideal choice for users of all levels. Whether you're a professional developer or just want to organize your life, \(appName) will help you achieve that goal."
        let fullDesc29 = "\(appName) is a simple and easy-to-use note taking application that will help you organize your life and not forget important moments. It provides a high level of security, a simple interface and a number of additional features that make it an ideal choice for users of all levels. If you are looking for a reliable tool to organize your life, \(appName) is a great choice for you."
        let fullDesc30 = "\(appName) is a handy notebook that allows you to quickly and easily write down everything you need. One of the main features of \(appName) is its simple and intuitive interface. You can easily get the hang of its functionality, even if you have had no previous experience with such applications. All the controls are located on one screen, which makes working with the application as convenient and efficient as possible."
        
        let fullDesc = [fullDesc21, fullDesc22, fullDesc23, fullDesc24, fullDesc25, fullDesc26, fullDesc27, fullDesc28, fullDesc29, fullDesc30, fullDesc1, fullDesc2, fullDesc3, fullDesc4, fullDesc5, fullDesc6, fullDesc7, fullDesc8, fullDesc9, fullDesc10, fullDesc11, fullDesc12, fullDesc13, fullDesc14, fullDesc15, fullDesc16, fullDesc17, fullDesc18, fullDesc19, fullDesc20]
        return fullDesc.randomElement() ?? fullDesc1
    }
    
    static func getShortDesc(appName: String) -> String {
        
        let shortDesc1 = "Write quickly and efficiently with \(appName)!!"

        let shortDesc2 = "Improve your productivity with \(appName)!!"

        let shortDesc3 = "\(appName) is your quick writing assistant!"

        let shortDesc4 = "Write faster and easier with \(appName)!"

        let shortDesc5 = "\(appName) is an innovative application for fast writing!"

        let shortDesc6 = "Save time with \(appName)!"

        let shortDesc7 = "\(appName) is your personal writing assistant!"

        let shortDesc8 = "Increase your efficiency with \(appName)!"

        let shortDesc9 = "Fast writing is made possible with \(appName)!"

        let shortDesc10 = "\(appName) - write quickly and easily on mobile devices!"

        let shortDesc11 = "Save time and effort with \(appName)!"

        let shortDesc12 = "\(appName) makes typing fast and easy!"

        let shortDesc13 = "\(appName) is your trusted texting assistant!"

        let shortDesc14 = "Improve your writing skills with \(appName)!"

        let shortDesc15 = "Faster, easier, more efficient - with \(appName)!"

        let shortDesc16 = "\(appName) is an intuitive app for fast writing!"

        let shortDesc17 = "Quick and accurate typing with \(appName)!"

        let shortDesc18 = "Increase your productivity with \(appName)!"

        let shortDesc19 = "\(appName) is your secret weapon in writing!"

        let shortDesc20 = "Faster, better, more efficient - with \(appName)!"
        let shortDesc21 = "Never forget an important thing with \(appName)!"
        let shortDesc22 = "Organize your life with \(appName)!"
        let shortDesc23 = "All the important moments in one place - in \(appName)!"
        let shortDesc24 = "Write down everything you need in \(appName)!"
        let shortDesc25 = "\(appName) is your personal assistant for organizing your life!"
        let shortDesc26 = "Easily and conveniently create notes with \(appName)!"
        let shortDesc27 = "\(appName) is a reliable tool for organizing your life!"
        let shortDesc28 = "Never miss an important thing with \(appName)!"
        let shortDesc29 = "Write down everything you need quickly and easily with \(appName)!"
        let shortDesc30 = "Stay organized with \(appName)!"
        let shortDesc = [shortDesc21, shortDesc22, shortDesc23, shortDesc24, shortDesc25, shortDesc26, shortDesc27, shortDesc28, shortDesc29, shortDesc30,
                         shortDesc1,
                         shortDesc2,
                         shortDesc3,
                         shortDesc4,
                         shortDesc5,
                         shortDesc6,
                         shortDesc7,
                         shortDesc8,
                         shortDesc9,
                         shortDesc10,
                         shortDesc11,
                         shortDesc12,
                         shortDesc13,
                         shortDesc14,
                         shortDesc15,
                         shortDesc16,
                         shortDesc17,
                         shortDesc18,
                         shortDesc19,
                         shortDesc20,
        ]
        return shortDesc.randomElement() ?? shortDesc1
    }
}
