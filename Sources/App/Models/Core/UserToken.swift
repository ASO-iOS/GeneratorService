//
//  File.swift
//  
//
//  Created by admin on 06.06.2023.
//

import Foundation

class UserToken {
    static let ALPHA_TOKEN = "pzrq4xj3evw3w3txu48hn8ghu"
    static let TEST_TOKEN = "dhjlyzq8cjrlz4twinmt49s2q"
    
    static let tokenList = [ALPHA_TOKEN, TEST_TOKEN]
    
    class func checkToken(_ token: String?) -> Bool {
        if token != nil {
            if tokenList.contains(token ?? "") {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
}
