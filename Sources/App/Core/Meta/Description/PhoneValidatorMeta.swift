//
//  File.swift
//  
//
//  Created by admin on 9/7/23.
//

import Foundation

struct PhoneValidatorMeta: MetaProviderProtocol {
    
    

    static func getFullDesc(appName: String) -> String {
        
        let fullDesc21 = "\(appName) is a convenient application for verifying the validity of phone numbers. Just enter the number, and the application will instantly check for compliance with the format and validity. The result will be information about whether the entered number is valid, as well as the country to which it belongs. It is a useful tool for business, marketing and personal use. You can confidently filter and process contact data, minimizing errors and improving the accuracy of your information. \(appName) provides fast and reliable number verification, helping you avoid misunderstandings and optimize your communications. Put aside non-existent or invalid numbers, making your work more efficient and professional."
        
        let fullDesc = [ fullDesc21]
        
        return fullDesc.randomElement() ?? fullDesc21
    }
    
    static func getShortDesc(appName: String) -> String {
        
        let shortDesc21 =  "\(appName): Check the number."
        
        
        let shortDesc = [shortDesc21]
        return shortDesc.randomElement() ?? shortDesc21
    }
    
    
}
