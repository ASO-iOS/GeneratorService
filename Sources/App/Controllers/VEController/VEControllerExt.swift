//
//  File.swift
//  
//
//  Created by admin on 31.07.2023.
//

import Foundation

extension VEController {
    func createAircraft(appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths, assetsLocation: String) {
        fileHandler.writeFile(filePath: path, contentText: VETypesOfAircraft.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: VETypesOfAircraft.fileName)
        do {
            if !FileManager.default.fileExists(atPath: assetsLocation) {
                try FileManager.default.createDirectory(atPath: assetsLocation, withIntermediateDirectories: true)
            }
        } catch {
            print(error)
        }
        
        fileHandler.writeFile(filePath: assetsLocation, contentText: VETypesOfAircraftAssets.content, fileName: VETypesOfAircraftAssets.name)
        
        fileHandler.writeFile(filePath: metaLoc, contentText: MetaHandler.fileContent(appName: appName, short: TypesOfAircraftMeta.getShortDesc(appName: appName), full: TypesOfAircraftMeta.getFullDesc(appName: appName), category: AppCategory.app_tools.rawValue), fileName: MetaHandler.fileName)
        
        fileHandler.createGradle(VETypesOfAircraft.self, packageName: packageName, gradlePaths: gradlePaths)
    }
    
    func createAlarm(appName: String, path: String, resPath: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths) {
        fileHandler.writeFile(filePath: path, contentText: VEAlarm.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: VEAlarm.fileName)
        fileHandler.writeFile(filePath: resPath, contentText: VEAlarmRes.alarmContent, fileName: VEAlarmRes.alarmName)
        fileHandler.writeFile(filePath: metaLoc, contentText: MetaHandler.fileContent(appName: appName, short: AlarmMeta.getShortDesc(appName: appName), full: AlarmMeta.getFullDesc(appName: appName), category: AppCategory.app_tools.rawValue), fileName: MetaHandler.fileName)
        
        fileHandler.createGradle(VEAlarm.self, packageName: packageName, gradlePaths: gradlePaths)
    }
    
    func createQuizBooks(appName: String, path: String, resPath: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths) {
        fileHandler.writeFile(filePath: path, contentText: VEQuizBooks.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: VEQuizBooks.fileName)
        fileHandler.writeFile(filePath: metaLoc, contentText: MetaHandler.fileContent(appName: appName, short: QuizMeta.getShortDesc(appName: appName), full: QuizMeta.getFullDesc(appName: appName), category: AppCategory.app_entertainment.rawValue), fileName: MetaHandler.fileName)
        fileHandler.writeFile(filePath: resPath, contentText: VEQuizBooksRes.content, fileName: VEQuizBooksRes.bookName)
        
        fileHandler.createGradle(VEQuizBooks.self, packageName: packageName, gradlePaths: gradlePaths)
    }
    
    func createFacts(appName: String, path: String, resPath: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths) {
        fileHandler.writeFile(filePath: path, contentText: VEFacts.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: VEFacts.fileName)
        fileHandler.writeFile(filePath: metaLoc, contentText: MetaHandler.fileContent(appName: appName, short: FactsMeta.getShortDesc(appName: appName), full: FactsMeta.getFullDesc(appName: appName), category: AppCategory.app_entertainment.rawValue), fileName: MetaHandler.fileName)
        fileHandler.writeFile(filePath: resPath, contentText: VEFactsRes.alarmContent, fileName: VEFactsRes.alarmName)
        
        fileHandler.createGradle(VEFacts.self, packageName: packageName, gradlePaths: gradlePaths)
        //        fileHandler.writeFile(filePath: gradlePaths.projectGradlePath, contentText: VEFacts.gradle(packageName).projectBuildGradle.content, fileName: VEFacts.gradle(packageName).projectBuildGradle.name)
        //        fileHandler.writeFile(filePath: gradlePaths.moduleGradlePath, contentText: VEFacts.gradle(packageName).moduleBuildGradle.content, fileName: VEFacts.gradle(packageName).moduleBuildGradle.name)
        //        fileHandler.writeFile(filePath: gradlePaths.dependenciesPath, contentText: VEFacts.gradle(packageName).dependencies.content, fileName: VEFacts.gradle(packageName).dependencies.name)
    }
    
    func createFindUniversity(appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths) {
        fileHandler.writeFile(filePath: path, contentText: VEFindUniversity.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: VEFindUniversity.fileName)
        
        fileHandler.writeFile(filePath: metaLoc, contentText: MetaHandler.fileContent(appName: appName, short: FindUniversityMeta.getShortDesc(appName: appName), full: FindUniversityMeta.getFullDesc(appName: appName), category: AppCategory.app_tools.rawValue), fileName: MetaHandler.fileName)
        
        fileHandler.createGradle(VEFindUniversity.self, packageName: packageName, gradlePaths: gradlePaths)
    }
    
    func createPassGen(appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths) {
        fileHandler.writeFile(filePath: path, contentText: VEPassGen.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: VEPassGen.fileName)
        fileHandler.createMeta(PassGeneratorMeta.self, metaLoc: metaLoc, category: .app_tools, appName: appName)
        fileHandler.createGradle(VEPassGen.self, packageName: packageName, gradlePaths: gradlePaths)
        
    }
    
    func createQuizVideoGames(appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths) {
        fileHandler.writeFile(filePath: path, contentText: VEQuizVideoGames.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: VEQuizVideoGames.fileName)
        
        
        fileHandler.createMeta(QuizVideoGamesMeta.self, metaLoc: metaLoc, category: .app_tools, appName: appName)
        // MARK: - todo meta
        fileHandler.createGradle(VEQuizVideoGames.self, packageName: packageName, gradlePaths: gradlePaths)
    }
    
    func createFactsAboutDogs(appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths) {
        fileHandler.writeFile(filePath: path, contentText: VEFactsAboutDogs.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: VEFactsAboutDogs.fileName)
        
        fileHandler.createMeta(FactsAboutDogsMeta.self, metaLoc: metaLoc, category: .app_tools, appName: appName)
        // MARK: - todo meta
        fileHandler.createGradle(VEFactsAboutDogs.self, packageName: packageName, gradlePaths: gradlePaths)
    }
    
    func createLuckySpan(appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths) {
        fileHandler.writeFile(filePath: path, contentText: VELuckySpan.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: VELuckySpan.fileName)
        
        fileHandler.createMeta(LuckySpanMeta.self, metaLoc: metaLoc, category: .app_tools, appName: appName)
        fileHandler.createGradle(VELuckySpan.self, packageName: packageName, gradlePaths: gradlePaths)
    }
    
    func createSoundRecorder(appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths) {
        fileHandler.writeFile(filePath: path, contentText: VESoundRecorder.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: VESoundRecorder.fileName)
        
        fileHandler.createMeta(SoundRecorderMeta.self, metaLoc: metaLoc, category: .app_tools, appName: appName)
        // MARK: - todo meta
        fileHandler.createGradle(VESoundRecorder.self, packageName: packageName, gradlePaths: gradlePaths)
    }
    
    func createCalendarEvents(appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths) {
        fileHandler.writeFile(filePath: path, contentText: VECalendarEvents.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: VECalendarEvents.fileName)
        
        fileHandler.createMeta(CalendarEventsMeta.self, metaLoc: metaLoc, category: .app_tools, appName: appName)
        // MARK: - todo meta
        fileHandler.createGradle(VECalendarEvents.self, packageName: packageName, gradlePaths: gradlePaths)
    }
    
    func createVigenereCipher(appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths) {
        fileHandler.writeFile(filePath: path, contentText: VEVigenereCipher.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: VEVigenereCipher.fileName)
        
        fileHandler.createMeta(VigenereCipherMeta.self, metaLoc: metaLoc, category: .app_tools, appName: appName)
        fileHandler.createGradle(VEVigenereCipher.self, packageName: packageName, gradlePaths: gradlePaths)
        
    }
    
    func createRandomWordQuiz(appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths) {
        fileHandler.writeFile(filePath: path, contentText: VERandomWordQuiz.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: VERandomWordQuiz.fileName)
        
        fileHandler.createMeta(RandomWordQuizMeta.self, metaLoc: metaLoc, category: .game_arcade, appName: appName)
        fileHandler.createGradle(VERandomWordQuiz.self, packageName: packageName, gradlePaths: gradlePaths)
    }
    
    func createRecipesBook(appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths) {
        fileHandler.writeFile(filePath: path, contentText: VERecipesBook.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: VERecipesBook.fileName)
        
        fileHandler.createMeta(RecipesBookMeta.self, metaLoc: metaLoc, category: .app_tools, appName: appName)
        fileHandler.createGradle(VERecipesBook.self, packageName: packageName, gradlePaths: gradlePaths)
    }
    
    func createRandomDogs(appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths, resPath: String) {
        fileHandler.writeFile(filePath: path, contentText: VERandomDogs.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: VERandomDogs.fileName)
        
        fileHandler.writeFile(filePath: resPath, contentText: VERandomDogsRes.petIcon.content, fileName: VERandomDogsRes.petIcon.name)
        fileHandler.createMeta(RandomDogsMeta.self, metaLoc: metaLoc, category: .app_tools, appName: appName)
        fileHandler.createGradle(VERandomDogs.self, packageName: packageName, gradlePaths: gradlePaths)
    }
    
    func createEnglishDictionaryHelper(appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths) {
        fileHandler.writeFile(filePath: path, contentText: VEEnglishDictionaryHelper.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: VEEnglishDictionaryHelper.fileName)
        
        fileHandler.createMeta(EnglishDictionaryHelperMeta.self, metaLoc: metaLoc, category: .app_tools, appName: appName)
        fileHandler.createGradle(VEEnglishDictionaryHelper.self, packageName: packageName, gradlePaths: gradlePaths)
    }
    
    func createNightBird(appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths, resPath: String) {
        fileHandler.writeFile(filePath: path, contentText: VENightBird.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: VENightBird.fileName)
        fileHandler.createMeta(BirdGameMeta.self, metaLoc: metaLoc, category: .game_arcade, appName: appName)
        fileHandler.createGradle(VENightBird.self, packageName: packageName, gradlePaths: gradlePaths)
    }
    
    func createChargeMe(appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths, resPath: String) {
        fileHandler.writeFile(filePath: path, contentText: VEChargeMe.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: VEChargeMe.fileName)
        fileHandler.writeFile(filePath: resPath, contentText: VEChargeMeRes.content, fileName: VEChargeMeRes.name)
        fileHandler.createMeta(ChargeMeMeta.self, metaLoc: metaLoc, category: .app_tools, appName: appName)
        fileHandler.createGradle(VEChargeMe.self, packageName: packageName, gradlePaths: gradlePaths)
    }
}
