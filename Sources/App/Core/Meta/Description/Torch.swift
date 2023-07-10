//
//  File.swift
//  
//
//  Created by admin on 07.07.2023.
//

import Foundation

struct TorchMeta {
    static let fullDesc1 = "Simple Torch is a simple and handy flashlight app that helps you illuminate dark corners and make your life a little easier. It offers a bright light for use in any environment, from looking for keys in a darkened room to walking around in the dark. The benefits of the Simple Torch are obvious: it's a simple and efficient way to get a bright light when you need it. You can use it anytime, anywhere, and adjust the brightness of the light to suit your needs."
    static let fullDesc2 = "Simple Torch is a mobile app that turns your smartphone into a bright flashlight. It's an app that's suitable for all ages and skill levels. It's simple and intuitive, so even beginners can quickly figure out how to use it. You can use it at work, at home, in the car, or on vacation. One of the main advantages of the Simple Torch is its bright light. It allows you to illuminate even the darkest corners and provides good visibility in all conditions. You can use it to find lost things, read in the dark, or just to create an atmospheric light."
    static let fullDesc3 = "If you are looking for a simple and reliable app to use as a flashlight, Simple Torch is exactly what you need. This is an app that will help you simplify your life and make it safer. It offers a bright light for use in any environment, as well as a number of additional features that can be useful in everyday life. You can use it anytime and anywhere, which makes it ideal for people who are looking for a simple and effective solution for lighting dark corners."
    static let fullDesc4 = "Ease of use is the main advantage of the Simple Torch. You can turn the flashlight on and off at the touch of a button, and you can adjust the brightness of the light depending on how much light you need. This makes the app ideal for people who are looking for a quick and easy solution for lighting dark corners. Simple Torch is an app that will help you simplify your life and make it safer. It offers a bright light for use in any environment, as well as a number of additional features that can be useful in everyday life. You can use it anytime and anywhere, which makes it ideal for people who are looking for a simple and effective solution for lighting dark corners."
    static let fullDesc5 = "Simple Torch is a bright beam. It allows you to illuminate even the darkest corners and provides good visibility in all conditions. You can use it to find lost things, read in the dark, or just to create an atmospheric light. Simple Torch also offers a number of additional features that can be useful in everyday life. For example, you can use it as a signal light for an accident on the road or as a beacon on the beach. In addition, you can adjust the brightness of the light to suit your needs."
    static let fullDesc6 = "If you are looking for a simple and reliable app to use as a flashlight, Simple Torch is just what you need. It is available for download on most mobile devices and is compatible with a variety of operating systems. It also has no ads or annoying notifications, making it even more convenient to use. No matter where you are or what task you're doing, Simple Torch will help you light your way quickly and easily and complete any task that requires light."
    static let fullDesc7 = "Simple Torch is a reliable and handy flashlight that will be an indispensable assistant in any situation when you need a light source. The app has a simple and clear interface that allows you to quickly turn the flashlight on or off at the touch of a button. The app also offers several light modes, including bright light, dim light, and flashing, allowing you to use the flashlight in different situations. There are also additional features, such as using your device's screen as a light source, and the ability to change the color of the flashlight's light to different shades to create the right atmosphere."
    static let fullDesc8 = "Simple Torch is a handy and reliable mobile app that turns your mobile device into a bright flashlight. It is designed to be used in various situations where you need a light source, such as in dark rooms, outside at night, or when you need to illuminate dark corners in your home.  Simple Torch has a simple and intuitive interface that allows you to quickly turn the flashlight on or off with the touch of a button. The app also offers several lighting modes, including bright light, dim light, and flashing, allowing you to use the flashlight in different situations."
    static let fullDesc9 = "If you're looking for a simple and reliable app to use as a flashlight, Simple Torch is just what you need. It is available for download on most mobile devices and is compatible with a variety of operating systems. It also has no ads or annoying notifications, making it even more convenient to use. No matter where you are or what task you are performing, Simple Torch will help you quickly and easily light your way and complete any task that requires light. Whether you're searching for keys in a dark corner, camping at night, or walking around town at night, the Simple Torch is your trusted and handy helper."
    static let fullDesc10 = "It's a reliable and handy flashlight that will be indispensable in any situation where you need a light source. Simple Torch also has additional features that make it even more convenient and practical. For example, the app allows you to adjust the brightness of the light, which saves the battery life of your device. In addition, Simple Torch is very convenient and practical because it doesn't take up much space on your device and you can use it anytime, anywhere."

    static let shortDesc1 = "Light up your life with Simple Torch!"
    static let shortDesc2 = "Simple Torch is your reliable and bright flashlight!"
    static let shortDesc3 = "Simple and practical light source in your pocket!"
    static let shortDesc4 = "Turn your phone into a powerful flashlight with a Simple Torch!"
    static let shortDesc5 = "Simple Torch, the reliable helper in the dark!"
    static let shortDesc6 = "Simple Torch is a fast, convenient way to light your way!"
    static let shortDesc7 = "Simple Torch - your reliable and bright light in the dark!"
    static let shortDesc8 = "Simple Torch, the ultimate flashlight for any situation!"
    static let shortDesc9 = "Simple Torch - never be left in the dark!"
    static let shortDesc10 = "Simple Torch - your reliable and bright source of light in any situation!"
    
    static func getFullDesc() -> String {
        let fullDesc = [fullDesc1, fullDesc2, fullDesc3, fullDesc4, fullDesc5, fullDesc6, fullDesc7, fullDesc8, fullDesc9, fullDesc10]
        return fullDesc.randomElement() ?? fullDesc1
    }
    
    static func getShortDesc() -> String {
        let shortDesc = [shortDesc1, shortDesc2, shortDesc3, shortDesc4, shortDesc5, shortDesc6, shortDesc7, shortDesc8, shortDesc9, shortDesc10]
        return shortDesc.randomElement() ?? shortDesc1
    }
}