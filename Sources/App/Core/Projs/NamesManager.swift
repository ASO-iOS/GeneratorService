//
//  File.swift
//  
//
//  Created by admin on 08.09.2023.
//

import Foundation

struct NamesManager {
    
    static let shared = NamesManager()
    
    private init() {}
    
    var directoryName: String {
        let lower = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
        var randomString = ""
        let len = Int.random(in: 4...16)
        for _ in 0..<len {
            randomString += lower.randomElement() ?? lower[0]
        }
        return randomString
    }
    
    var fileName: String {
        let lower = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
        let upper = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
        var randomString = upper.randomElement() ?? upper[0]
        let len = Int.random(in: 8...20)
        for _ in 0..<len {
            randomString += Int.random(in: 0...1) == 0 ? lower.randomElement() ?? lower[0] : upper.randomElement() ?? upper[0]
        }
        return randomString
    }
    
    func makeFakeKotlinName(len: Int) -> String {
        let regular = Int.random(in: 0...2)
        if regular == 0 {
            return fileName + ".kt"
        } else {
            return (fakeFileName.randomElement() ?? fakeFileName[0]) + ".kt"
        }
    }
    
    private var fakeFileName: [String] {
        return [
            "HelloWorld",
            "MyUtils",
            "DataModel",
            "NetworkUtils",
            "StringUtils",
            "MathUtils",
            "Constants",
            "Hello",
            "StringUtils",
            "UserData",
            "Utils",
            "Parser",
            "DatabaseHelper",
            "Validator",
            "ViewAdapter",
            "LogUtils",
            "RequestManager",
            "APIManager",
            "FileManager",
            "ErrorHandler",
            "Authentication",
            "ImageLoader",
            "SortUtils",
            "DataUtils",
            "FragmentUtils",
            "ListAdapter",
            "EncryptionUtils",
            "DecryptionUtils",
            "BackupManager",
            "MediaUtils",
            "GestureUtils",
            "AnimationHelper",
            "EmailUtils",
            "GeocoderUtils",
            "Mzxnbn",
            "Eausit",
            "Yqtylg",
            "Dazwyv",
            "Fcowuj",
            "Pjodye",
            "Qcvmcs",
            "Akmoes",
            "Wbpzxu",
            "Iekvnw",
            "Trjian",
            "Xkezlg",
            "Nrispa",
            "Hiaygo",
            "Lmxwqd",
            "Otascl",
            "Zbwxun",
            "Iqxetb",
            "Vjdhpx",
            "Smafeo",
            "Yfgkrl",
            "Xiquau",
            "Gkwidp",
            "Nljtsy",
            "Pwjoeb",
            "Corgsl",
            "Fikwbn",
            "Xytpdm",
            "Pzovul",
            "Bmvtlo",
            "Uqyexr",
            "Mxwkra",
            "Jzfgkp",
            "Qfhmjt",
            "Wugqok",
            "Ecbklf",
            "Vfbult",
            "Dhtmeq",
            "Qvmpbd",
            "Lobtzs",
            "Xsnryi"
        ]
    }
    
    let ars = """
Time Tracker
Time Keeper
Time Counter
ChronoGo
Time Master
Tick Tock
Time Chronograph
Time Control
Fast Time
"""
}
