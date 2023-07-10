//
//  File.swift
//  
//
//  Created by admin on 07.07.2023.
//

import Foundation

struct CalculatorMeta {
    static let fullDesc1 = "This is an application for solving mathematical calculations. It allows you to perform arithmetic operations such as addition, subtraction, multiplication, and division quickly and conveniently. The calculator has a simple and intuitive interface that makes it easy to enter data and get results. It can be useful for schoolchildren, students, businessmen and anyone who needs fast and accurate solutions of mathematical problems."
    static let fullDesc2 = "It is a handy application for solving mathematical calculations. You can use it to perform arithmetic operations quickly and accurately. The intuitive interface makes it easy to enter data and get results. It is an indispensable tool for schoolchildren, students, businessmen and everyone who needs fast solution of mathematical problems."
    static let fullDesc3 = "Calculator is a reliable assistant in everyday life. It allows you to perform basic operations such as addition, subtraction, multiplication and division. The calculator has a simple and user-friendly interface that allows you to enter numbers and operators quickly and easily."
    static let fullDesc4 = "Calculator is an app for mathematical calculations on your mobile device. It is an essential tool for anyone working with numbers, whether a student, student or professional mathematician. It allows you to perform basic operations such as addition, subtraction, multiplication and division. The calculator has a simple and intuitive interface that makes entering numbers and operators quick and easy."
    static let fullDesc5 = "Calculator is a mobile app that helps you perform mathematical calculations. It is an essential tool for students, students, and professionals who work with numbers. You can use the calculator to add, subtract, multiply and divide numbers, and perform other mathematical operations."
    static let fullDesc6 = " A calculator is a quick and easy way to solve math problems on the go. The calculator has a simple and clear interface, which makes it easy to use for any user. It can be useful in various areas of life, from studying to financial planning."
    static let fullDesc7 = "Calculator is an application that allows you to perform arithmetic operations on your mobile device. A calculator is an indispensable tool for anyone who needs to calculate numbers quickly and accurately. You can use the calculator to perform basic operations such as addition, subtraction, multiplication and division."
    static let fullDesc8 = "A calculator is a reliable helper in everyday life. The calculator has a simple and intuitive interface, making it easy to use for any user. It can be useful in everyday life, as well as in studies and work."
    static let fullDesc9 = "It is an application for mobile devices, which allows performing various mathematical operations. With the calculator you can quickly and easily perform basic operations such as addition, subtraction, multiplication and division. Overall, the calculator is an indispensable tool for anyone who needs to calculate numbers quickly and accurately."
    static let fullDesc10 = "Calculator is an application that allows you to perform various mathematical operations on your mobile device. Calculator has a simple and intuitive interface that allows the user to get used to the application quickly and easily. It can be useful in everyday life, study and work."

    static let shortDesc1 = "A simple calculator for quick calculations!"
    static let shortDesc2 = "Simple calculator for easy calculations!"
    static let shortDesc3 = "Fast calculator for quick calculations!"
    static let shortDesc4 = "Quick calculator for easy calculations!"
    static let shortDesc5 = "Basic calculator for elementary operations!"
    static let shortDesc6 = "Elementary calculator for quick calculations!"
    static let shortDesc7 = "Quick calculator for basic operations!"
    static let shortDesc8 = "Simple calculator for basic operations!"
    static let shortDesc9 = "A basic calculator for quick calculations!"
    static let shortDesc10 = "Easy calculator for quick calculations!"
    
    static func getFullDesc() -> String {
        let fullDesc = [fullDesc1, fullDesc2, fullDesc3, fullDesc4, fullDesc5, fullDesc6, fullDesc7, fullDesc8, fullDesc9, fullDesc10]
        return fullDesc.randomElement() ?? fullDesc1
    }
    
    static func getShortDesc() -> String {
        let shortDesc = [shortDesc1, shortDesc2, shortDesc3, shortDesc4, shortDesc5, shortDesc6, shortDesc7, shortDesc8, shortDesc9, shortDesc10]
        return shortDesc.randomElement() ?? shortDesc1
    }
}
