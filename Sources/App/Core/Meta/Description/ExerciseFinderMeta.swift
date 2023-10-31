//
//  File.swift
//  
//
//  Created by admin on 9/7/23.
//

import Foundation

struct ExerciseFinderMeta: MetaProviderProtocol {
    
    static func getFullDesc(appName: String) -> String {
        let fullDesc21 = "\(appName) is a convenient application for finding exercises. Just enter a query and the app will provide you with a suitable exercise with the name, target muscle group, instructions for performing and difficulty level. Whether you are a beginner or an experienced athlete, \(appName) will help you diversify your workouts, focus on the right muscles and follow the correct technique. With a wide range of exercises and targeted muscle groups, the app will become your reliable assistant in achieving physical goals. Easily find exercises for different body parts and difficulty levels. \(appName) will help you plan and diversify your workouts effectively, making your path to physical fitness more interesting and productive. Take your workouts to the next level with \(appName)!"
        let fullDesc = [ fullDesc21]
        
        return fullDesc.randomElement() ?? fullDesc21
    }
    
    static func getShortDesc(appName: String) -> String {
        let shortDesc21 =  "\(appName): Look for exercises."
        let shortDesc = [shortDesc21]
        return shortDesc.randomElement() ?? shortDesc21
    }
    
    
}
