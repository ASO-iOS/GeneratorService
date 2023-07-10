//
//  File.swift
//  
//
//  Created by admin on 07.07.2023.
//

import Foundation

struct PaintAppMeta {
    static let fullDesc1 = "Paint is a mobile app that allows you to express your creative nature and create amazing works of art right on your device. With this app you can become a true artist and immerse yourself in a world of endless possibilities. Paint offers you a wide range of tools and features to bring your ideas to life. It has a simple and intuitive interface, making it accessible to users of all ages and skill levels. With a variety of brushes, pencils, markers, and other tools, you can create unique drawings and illustrations."
    static let fullDesc2 = "One of the features of Paint is the ability to work with different layers. Layers allow you to create complex compositions, add details, and make changes without affecting the rest of your drawing. You can move, resize, hide, or change the transparency of layers to achieve the effect you want. Paint also offers a wide selection of colors and palettes so you can choose the perfect hues for your artwork. You can mix colors, create gradients, and add shadows and effects to give your artwork depth and dimension."
    static let fullDesc3 = "Paint is not only a drawing tool but also a source of inspiration. The app offers a gallery of hundreds of templates and ideas to help you start or give a new direction to your creativity. You can explore other users' work, share your accomplishments, and get feedback and support from the artist community. In addition, Paint offers the ability to save your artwork in a variety of formats so you can share it with friends and family or use it in your projects. You can also export your work to social media or send it via email."
    static let fullDesc4 = "Paint also offers a number of additional features to help you with your work. You can use tools to crop, scale, and rotate images to create unique compositions. You can also add text and captions to your artwork to send the right message or share your thoughts. Paint is a powerful and versatile mobile app for artists and creatives. It gives you all the tools and features you need to create amazing artwork right on your device. Dive into the world of creativity with Paint and let your imagination run wild! "
    static let fullDesc5 = "Paint is an amazing mobile app that opens up a world of endless creative possibilities for you. With its help you will be able to implement your most daring ideas in painting and create real works of art directly on your device. One of the key features of Paint is its simple and intuitive interface. You will be able to easily master all the functions of the application even without any special skills in drawing. The interface is designed so that you can focus on your creativity and not be distracted by the complexity of using the app."
    static let fullDesc6 = "Paint offers you a wide range of tools and features so that you can express your creative nature. You can use a variety of brushes, markers, pencils and other tools to create unique drawings and illustrations. With a variety of effects and filters, you can add special charm and expression to your artwork. One of the most important tools in Paint is the choice of color palette. You can choose from over a thousand different shades to create the perfect color combinations for your artwork. You can mix colors, create gradients and add shadows to give your artwork depth and volume."
    static let fullDesc7 = "Paint is not only a tool for creating artwork, but also a source of inspiration. In the app, you'll find a gallery of hundreds of templates and ideas to help you get started or give a new direction to your artwork. You'll be able to explore other artists' work, share your accomplishments, and get feedback and support from a community of creative people. Paint also offers the ability to work with different layers, allowing you to create complex compositions and add detail without affecting the rest of your drawing. You can move, resize, change transparency, and apply different effects to each layer to achieve the effect you want."
    static let fullDesc8 = "This is a mobile app that allows users to express their creative nature and create amazing works of art right on their device. This app offers a wide range of tools and features to bring ideas to life, with a simple and intuitive interface suitable for users of all ages and skill levels. With the Paint app, users can use a variety of brushes, pencils, markers, and other tools to create unique drawings and illustrations. The app also provides a wide selection of colors and palettes so users can choose the perfect shades for their artwork. Users can mix colors, create gradients, and add shadows and effects to add depth and dimension to their artwork."
    static let fullDesc9 = "The Paint app also provides handy tools for working with text, allowing users to add captions, headings, and signatures to their artwork. This opens up possibilities for creating beautiful quotes, designing logos, or simply adding information to illustrations. Another important feature of Paint is the ability to save and export work in a variety of formats, including high-resolution images, so users can share their creations with friends and publish them to social networks or websites."
    static let fullDesc10 = "\"Paint\" also offers the ability to import photos and images from the device's gallery so users can use them in their creative projects. This opens up additional possibilities for transforming and modifying existing images. Overall, the \"Paint\" app is a powerful tool for creativity and self-expression that allows users to create gorgeous works of art right on their mobile device. Thanks to its versatility and simple interface, \"Paint\" is suitable for both novice artists and experienced professionals who are looking for a convenient and mobile solution for their creativity."

    static let shortDesc1 = "Paint the world with Paint, the best drawing app on your phone!"
    static let shortDesc2 = "Bring your creative ideas to life with Paint, the easy and convenient drawing app!"
    static let shortDesc3 = "Masterpieces on your phone with Paint, the app that's always at your fingertips!"
    static let shortDesc4 = "Color up your routine with Paint, an app that lets you draw anytime, anywhere!"
    static let shortDesc5 = "Paint is your pocket artist, always ready to capture your ideas!"
    static let shortDesc6 = "Breathe life into your drawings with Paint, an app that offers many tools and effects!"
    static let shortDesc7 = "Unleash your creativity with Paint, an app that makes drawing easy and fun!"
    static let shortDesc8 = "Paint is your magic paintbrush that lets you create works of art on your phone!"
    static let shortDesc9 = "Draw your dreams with Paint, an app that helps you bring any idea to life on your phone screen!"
    static let shortDesc10 = "Paint is your perfect companion for creativity that fits in your pocket!"
    
    static func getFullDesc() -> String {
        let fullDesc = [fullDesc1, fullDesc2, fullDesc3, fullDesc4, fullDesc5, fullDesc6, fullDesc7, fullDesc8, fullDesc9, fullDesc10]
        return fullDesc.randomElement() ?? fullDesc1
    }
    
    static func getShortDesc() -> String {
        let shortDesc = [shortDesc1, shortDesc2, shortDesc3, shortDesc4, shortDesc5, shortDesc6, shortDesc7, shortDesc8, shortDesc9, shortDesc10]
        return shortDesc.randomElement() ?? shortDesc1
    }
}
