//
//  File.swift
//  
//
//  Created by admin on 9/1/23.
//

import Foundation

struct ROT13EncryptMeta: MetaProviderProtocol {
    
    
    
    
    static func getFullDesc(appName: String) -> String {
        
        let fullDesc21 = "\(appName) is a convenient and fast application for encrypting text using the ROT13 method. Just enter your text, and the application will instantly encrypt it using the ROT13 algorithm, which replaces each letter with a letter located 13 positions after it in the alphabet. This is a simple and reliable encryption method that is suitable for protecting small messages from accidental glances. The encrypted text can be easily copied and sent to friends via messengers or email. The application also provides a function to decrypt the text back to its original state. \(appName) is ideal for those who want to exchange encrypted messages and at the same time not bother with complex encryption methods. Protect your communication with \(appName) - easy to protect information!"
        
        let fullDesc1 = "\(appName) is a mobile app that provides a simple and easy way to encrypt text using the ROT13 cipher. ROT13 is a simple encryption method that replaces each letter in the alphabet with a letter 13 positions forward or backward. \(appName) is a reliable and handy application that provides secure encryption and decryption of text messages. With its simple interface and fast operation, users will be able to use the application effectively in various situations where sensitive information needs to be exchanged. \(appName) is your reliable assistant in protecting your private data. Download \(appName) now and start using it for secure messaging!"

        let fullDesc2 = "One of the main features of \(appName) is its ease of use. Users just need to enter the text they want to encrypt and click the \"Encrypt\" button. The application will instantly perform the encryption and display the encrypted text on the screen. This makes \(appName) the perfect tool for fast and secure messaging. \(appName) is a mobile app that provides an easy and convenient way to encrypt text using the ROT13 cipher. ROT13 is an encryption method that replaces each letter in the alphabet with a letter 13 positions forward or backward."

        let fullDesc3 = "\(appName) offers the ability to decrypt the encrypted text back to the original text. To do this, the user must enter the encrypted text and click the \"Decrypt\" button. The app will instantly perform the decryption and display the original text on the screen. This allows users to easily share encrypted messages and effortlessly decrypt them when needed. The main feature of \(appName) is its ease of use. To encrypt text, the user just needs to enter the desired text and click on the \"Encrypt\" button. The application will instantly perform the encryption and display the encrypted text on the screen. This makes \(appName) the perfect tool for fast and secure messaging."

        let fullDesc4 = "\(appName) also offers additional features that make it even more convenient and functional. For example, the application allows the user to copy encrypted or decrypted text to the clipboard, making it easy to paste it into other applications or send it via messages. Additionally, the app saves a history of all encrypted and decrypted texts, allowing users to easily return to them at any time. \(appName) offers the ability to decrypt the encrypted text back to the original text. To do so, the user has to enter the encrypted text and click on the \"Decrypt\" button. The app will instantly perform the decryption and display the original text on the screen. This allows users to easily share encrypted messages and effortlessly decrypt them when needed."

        let fullDesc5 = "\(appName) has a simple and intuitive interface that makes it accessible to a wide range of users. The design of the application is simple and minimalistic, allowing users to focus on the core functionality without distractions. All controls are located on the home screen, making navigation through the application quick and easy. \(appName) also offers additional features that make it even more convenient and functional. For example, the app allows the user to copy encrypted or decrypted text to the clipboard, making it easier to use in other apps or send via messaging. In addition, the app saves a history of all encrypted and decrypted texts, allowing users to easily return to them at any time."

        let fullDesc6 = "\(appName) is a useful tool for those who want to protect their personal data and messages from unauthorised parties. Encryption with ROT13 can be used to protect sensitive information that needs to be transmitted through unsecured communication channels. The application allows you to encrypt and decrypt text quickly and efficiently, ensuring the security and confidentiality of correspondence. \(appName) has a simple and intuitive interface that makes it accessible to a wide range of users. The design of the application is simple and minimalistic, which helps users focus on the core functionality without distractions. All controls are located on the home screen, making navigation through the application quick and easy."

        let fullDesc7 = "\(appName) is a simple and easy-to-use mobile app that provides users with the ability to encrypt and decrypt text using the ROT13 cipher. It features a simple interface, advanced features and history saving, making it an ideal choice for anyone who needs to quickly and securely protect their messages. \(appName) is a useful tool for those who want to protect their private data and messages from unauthorised parties. Encryption with ROT13 can be used to protect sensitive information that needs to be transmitted through unsecured communication channels. The application allows you to encrypt and decrypt text quickly and efficiently, ensuring the security and confidentiality of correspondence."

        let fullDesc8 = "\(appName) is a handy and easy-to-use mobile application that provides the ability to encrypt and decrypt text messages using the ROT13 algorithm. ROT13 is an encryption method that replaces each letter in the alphabet with a letter that is 13 positions further away. Thus, the \(appName) application allows you to securely transmit and store sensitive information. \(appName) is a simple and easy-to-use mobile app that provides users with the ability to encrypt and decrypt text using the ROT13 cipher. It features a simple interface, advanced features and history saving, making it an ideal choice for anyone who needs to quickly and securely protect their messages."

        let fullDesc9 = "One of the main features of \(appName) is its simple and intuitive interface. Users will be able to quickly learn all the app's features and start encrypting and decrypting their messages in just a few minutes. With its minimalistic design and easy navigation, users will be able to focus on the encryption process itself without being distracted by the complexities of using the app. \(appName) is a unique and innovative mobile application designed to encrypt and decrypt text messages using the robust ROT13 algorithm, providing a high degree of security and privacy when transmitting and storing important information."

        let fullDesc10 = "\(appName) offers several ways to encrypt and decrypt text. Users can enter text directly into the application or copy it from other sources such as messages, emails or documents. After entering the text, the user can select the encryption or decryption option and get the result in the form of encrypted or decrypted text. The main feature of \(appName) is its simple and intuitive interface that allows users to easily learn all the features of the application. Thanks to its minimalistic design and easy navigation, users can focus on the encryption process itself without being distracted by the complexities of using the application."
        
        let fullDesc11 = "One of the advantages of \(appName) is its fast performance. The application is fast and lag-free, allowing users to get instant encryption and decryption results. Due to this, users can effectively use \(appName) in their daily life such as exchanging confidential messages or storing personal records. \(appName) offers several ways to encrypt and decrypt text. Users can enter text directly into the application or copy it from other sources such as messages, emails or documents. After entering the text, the user can select the encryption or decryption option and get the result in the form of encrypted or decrypted text."

        let fullDesc12 = "\(appName) also offers the ability to save encrypted or decrypted text as a file. This allows users to save important information on the device and access it at any time. In addition, the application supports the ability to send encrypted or decrypted messages through various communication channels such as email or messengers. One of the advantages of \(appName) is its fast speed. The application is fast and lag-free, which allows users to receive encryption and decryption results instantly. Due to this, users can effectively use \(appName) in their daily life such as exchanging confidential messages or storing personal records."

        let fullDesc13 = "Security is one of the main objectives of \(appName). All data entered by the user into the application is protected using strong encryption algorithms to ensure that the information is kept safe. Users can rest assured that their messages will remain private and will not fall into the wrong hands. \(appName) also offers the ability to save encrypted or decrypted text as a file. This allows users to save important information on their device and access it at any time. In addition, the app supports the ability to send encrypted or decrypted messages through various communication channels such as email or messengers."

        let fullDesc14 = "\(appName) is a reliable and handy application that provides secure encryption and decryption of text messages. Thanks to its simple interface and fast operation, users will be able to use the application effectively in various situations where sensitive information needs to be shared. \(appName) is your trusted assistant in protecting your private data. Security is one of the main objectives of \(appName). All the data entered by the user in the application is protected using strong encryption algorithms to keep the information safe. Users can rest assured that their messages will remain private and will not fall into the wrong hands."

        let fullDesc15 = "\(appName) is a handy and easy-to-use mobile application that is designed to encrypt and decrypt text messages using the ROT13 algorithm. ROT13 is an encryption method that replaces each letter in the alphabet with a letter that is 13 positions further away. Thus, the \(appName) application provides security in the transmission and storage of sensitive information. \(appName) is a reliable and user-friendly application that provides secure encryption and decryption of text messages. With its simple interface and fast operation, users will be able to use the application effectively in various situations where sensitive information needs to be exchanged. \(appName) is your reliable assistant in protecting your private data. Download \(appName) right now and start using it for secure messaging!"

        let fullDesc16 = "One of the main features of \(appName) is its simple and intuitive interface. Users will be able to quickly learn all the app's features and start encrypting and decrypting their messages in just a few minutes. With its minimalistic design and easy navigation, users will be able to focus on the encryption process itself without being distracted by the complexities of using the app. \(appName) is a convenient and easy-to-use mobile app that provides the ability to encrypt and decrypt text using the ROT13 cipher. ROT13 is an encryption method that replaces each letter in the alphabet with a letter 13 positions forward or backward."

        let fullDesc17 = "\(appName) offers several ways to encrypt and decrypt text. Users can enter text directly into the app or copy it from other sources such as messages, emails or documents. After entering the text, the user can select the encryption or decryption option and get the result in the form of encrypted or decrypted text. One of the main features of \(appName) is its ease of use. To encrypt text, the user just needs to enter the desired text and click on the \"Encrypt\" button. The application will instantly perform the encryption and display the encrypted text on the screen. This makes \(appName) an ideal tool for fast and secure messaging."

        let fullDesc18 = "One of the advantages of \(appName) is its high speed. The application is fast and lag-free, allowing users to receive encryption and decryption results instantly. Due to this, users can effectively use \(appName) in their daily lives, such as exchanging confidential messages or storing personal records. \(appName) offers the ability to decrypt the encrypted text back to the original text. To do this, the user has to enter the encrypted text and click on the \"Decrypt\" button. The app will instantly perform the decryption and display the original text on the screen. This allows users to easily share encrypted messages and effortlessly decrypt them when needed."

        let fullDesc19 = "\(appName) also offers the ability to save encrypted or decrypted text as a file. This allows users to save important information on the device and access it at any time. In addition, the app supports the ability to send encrypted or decrypted messages through various communication channels such as email or messengers. \(appName) also offers additional features that make it even more convenient and functional. For example, the app allows the user to copy encrypted or decrypted text to the clipboard, making it easier to use it in other applications or send it via messaging. In addition, the app keeps a history of all encrypted and decrypted texts, allowing users to easily refer back to them at any time."

        let fullDesc20 = "Security is one of the main objectives of \(appName). All data entered by the user into the application is protected using strong encryption algorithms, which ensures the safety of the information. Users can rest assured that their messages will remain private and will not fall into the wrong hands. \(appName) has a simple and intuitive interface that makes it accessible to a wide range of users. The design of the application is simple and minimalistic, which helps users focus on the core functionality without distractions. All controls are located on the home screen, making navigation through the application quick and easy."
        
        let fullDesc = [fullDesc1, fullDesc2, fullDesc3, fullDesc4, fullDesc5, fullDesc6, fullDesc7, fullDesc8, fullDesc9, fullDesc10, fullDesc11, fullDesc12, fullDesc13, fullDesc14, fullDesc15, fullDesc16, fullDesc17, fullDesc18, fullDesc19, fullDesc20, fullDesc21]
        
        return fullDesc.randomElement() ?? fullDesc21
    }
    
    static func getShortDesc(appName: String) -> String {
        let shortDesc1 = "\(appName) - one-touch protection for your messages!"

        let shortDesc2 = "\(appName) is an easy way to keep your data safe!"

        let shortDesc3 = "\(appName) is your trusted partner in encrypting your messages!"

        let shortDesc4 = "\(appName) - fast and secure text encryption!"

        let shortDesc5 = "\(appName) - lightweight encryption for increased privacy!"

        let shortDesc6 = "\(appName) is your personal weapon in the fight against unsecured messages!"

        let shortDesc7 = "\(appName) - simply but effectively encrypt your data!"

        let shortDesc8 = "\(appName) - protect your private messages from prying eyes!"

        let shortDesc9 = "\(appName) - a powerful tool for securely sharing information!"

        let shortDesc10 = "\(appName) - secure encryption on your mobile device!"

        let shortDesc11 = "\(appName) - simplicity and security in one application!"

        let shortDesc12 = "\(appName) - fast and easy encryption for increased privacy!"

        let shortDesc13 = "\(appName) is your defence against prying eyes!"

        let shortDesc14 = "\(appName) - simple and strong encryption for everyone!"

        let shortDesc15 = "\(appName) is your trusted companion in protecting your communications!"

        let shortDesc16 = "\(appName) - lightweight encryption for enhanced security!"

        let shortDesc17 = "\(appName) is your privacy tool!"

        let shortDesc18 = "\(appName) - fast and effective encryption for all occasions!"

        let shortDesc19 = "\(appName) - ease of use combined with reliability!"

        let shortDesc20 = "\(appName) - your solution for protecting data on your mobile device!"


        
        let shortDesc21 =  "\(appName): Fast encryption!"
        
        let shortDesc = [shortDesc1, shortDesc2, shortDesc3, shortDesc4, shortDesc5, shortDesc6, shortDesc7, shortDesc8, shortDesc9, shortDesc10, shortDesc11, shortDesc12, shortDesc13, shortDesc14, shortDesc15, shortDesc16, shortDesc17, shortDesc18, shortDesc19, shortDesc20, shortDesc21]
        return shortDesc.randomElement() ?? shortDesc21
    }
    
    
}
