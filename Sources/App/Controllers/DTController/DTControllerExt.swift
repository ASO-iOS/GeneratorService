//
//  File.swift
//  
//
//  Created by admin on 01.09.2023.
//

import Foundation

extension DTController {
    func createNumbersFacts (appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths, resPath: String, mainData: MainData) {
        fileHandler.writeFile(filePath: path, contentText: DTNumberFacts.mainFragmentCMF(mainData).content, fileName: DTNumberFacts.mainFragmentCMF(mainData).fileName)
        
        fileHandler.createMeta(NumbersFactsMeta.self, metaLoc: metaLoc, category: .app_tools, appName: appName)
        fileHandler.createGradle(DTNumberFacts.self, packageName: packageName, gradlePaths: gradlePaths)
    }
    
    func createProgrammingJokes(appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths, resPath: String, mainData: MainData) {
        fileHandler.writeFile(filePath: path, contentText: DTProgrammingJokes.mainFragmentCMF(mainData).content, fileName: DTProgrammingJokes.mainFragmentCMF(mainData).fileName)
        
        fileHandler.createMeta(ProgrammingJokesMeta.self, metaLoc: metaLoc, category: .app_tools, appName: appName)
        fileHandler.createGradle(DTProgrammingJokes.self, packageName: packageName, gradlePaths: gradlePaths)
    }
    
    func createQrGenShare(appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths, resPath: String, mainData: MainData, xmlPaths: XMLLayoutPaths) {
        fileHandler.writeFile(filePath: path, contentText: DTQrGenShare.mainFragmentCMF(mainData).content, fileName: DTQrGenShare.mainFragmentCMF(mainData).fileName)
        fileHandler.writeFile(filePath: xmlPaths.valuesPath, contentText: DTQrGenShareRes.icon.content, fileName: DTQrGenShareRes.icon.name)
        
        fileHandler.createMeta(QrGenShareMeta.self, metaLoc: metaLoc, category: .app_tools, appName: appName)
        fileHandler.createGradle(DTQrGenShare.self, packageName: packageName, gradlePaths: gradlePaths)
    }
    
    func createRot13Encrypt(appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths, resPath: String, mainData: MainData, xmlPaths: XMLLayoutPaths) {
        fileHandler.writeFile(filePath: path, contentText: DTRot13Encrypt.mainFragmentCMF(mainData).content, fileName: DTRot13Encrypt.mainFragmentCMF(mainData).fileName)
        fileHandler.writeFile(filePath: xmlPaths.valuesPath, contentText: DTRot13EncryptRes.icon.content, fileName: DTRot13EncryptRes.icon.name)
        
        fileHandler.createMeta(ROT13EncryptMeta.self, metaLoc: metaLoc, category: .app_tools, appName: appName)
        fileHandler.createGradle(DTRot13Encrypt.self, packageName: packageName, gradlePaths: gradlePaths)
    }
    
    func createTextSimilarity(appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths, resPath: String, mainData: MainData, xmlPaths: XMLLayoutPaths) {
        fileHandler.writeFile(filePath: path, contentText: DTTextSimilarity.mainFragmentCMF(mainData).content, fileName: DTTextSimilarity.mainFragmentCMF(mainData).fileName)
        fileHandler.writeFile(filePath: xmlPaths.valuesPath, contentText: DTTextSimilarityRes.icon.content, fileName: DTTextSimilarityRes.icon.name)
        
        fileHandler.createMeta(TextSimilarityMeta.self, metaLoc: metaLoc, category: .app_tools, appName: appName)
        fileHandler.createGradle(DTTextSimilarity.self, packageName: packageName, gradlePaths: gradlePaths)
        
    }
    
    func createRiddleRealm(appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths, resPath: String, mainData: MainData, xmlPaths: XMLLayoutPaths) {
        fileHandler.writeFile(filePath: path, contentText: DTRiddleRealm.mainFragmentCMF(mainData).content, fileName: DTRiddleRealm.mainFragmentCMF(mainData).fileName)
        fileHandler.writeFile(filePath: xmlPaths.valuesPath, contentText: DTRiddleRealmRes.icon.content, fileName: DTRiddleRealmRes.icon.name)
        
        ///MARK: TodoMeta
        fileHandler.createGradle(DTRiddleRealm.self, packageName: packageName, gradlePaths: gradlePaths)
    }
    
    func createNutritionFinder(appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths, resPath: String, mainData: MainData, xmlPaths: XMLLayoutPaths) {
        fileHandler.writeFile(filePath: path, contentText: DTNutritionFinder.mainFragmentCMF(mainData).content, fileName: DTNutritionFinder.mainFragmentCMF(mainData).fileName)
        fileHandler.writeFile(filePath: xmlPaths.valuesPath, contentText: DTNutritionFinderRes.icon.content, fileName: DTNutritionFinderRes.icon.name)
        fileHandler.writeFile(filePath: xmlPaths.drawablePath, contentText: DTNutritionFinderRes.iconSec.content, fileName: DTNutritionFinderRes.iconSec.name)
        
        fileHandler.createMeta(NutritionFinderMeta.self, metaLoc: metaLoc, category: .app_tools, appName: appName)
        fileHandler.createGradle(DTNutritionFinder.self, packageName: packageName, gradlePaths: gradlePaths)
        
    }
    
    func createEmojiFinder(appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths, resPath: String, mainData: MainData, xmlPaths: XMLLayoutPaths) {
        fileHandler.writeFile(filePath: path, contentText: DTEmojiFinder.mainFragmentCMF(mainData).content, fileName: DTEmojiFinder.mainFragmentCMF(mainData).fileName)
        fileHandler.writeFile(filePath: xmlPaths.valuesPath, contentText: DTEmojiFinderRes.icon.content, fileName: DTEmojiFinderRes.icon.name)
        
        fileHandler.createMeta(EmojiFinderMeta.self, metaLoc: metaLoc, category: .app_tools, appName: appName)
        fileHandler.createGradle(DTEmojiFinder.self, packageName: packageName, gradlePaths: gradlePaths)
    }
    
    func createEasyNotes(appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths, resPath: String, mainData: MainData, xmlPaths: XMLLayoutPaths){
        fileHandler.writeFile(filePath: path, contentText: DTEasyNotes.mainFragmentCMF(mainData).content, fileName: DTEasyNotes.mainFragmentCMF(mainData).fileName)
        fileHandler.writeFile(filePath: xmlPaths.valuesPath, contentText: DTEasyNotesRes.icon.content, fileName: DTEasyNotesRes.icon.name)
        
        fileHandler.createMeta(EasyNotesMeta.self, metaLoc: metaLoc, category: .app_tools, appName: appName)
        fileHandler.createGradle(DTEasyNotes.self, packageName: packageName, gradlePaths: gradlePaths)
    }
    
    func createExerciseFinder(appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths, resPath: String, mainData: MainData, xmlPaths: XMLLayoutPaths){
        fileHandler.writeFile(filePath: path, contentText: DTExerciseFinder.mainFragmentCMF(mainData).content, fileName: DTExerciseFinder.mainFragmentCMF(mainData).fileName)
        fileHandler.writeFile(filePath: xmlPaths.valuesPath, contentText: DTExerciseFinderRes.icon.content, fileName: DTExerciseFinderRes.icon.name)
        
        fileHandler.createMeta(ExerciseFinderMeta.self, metaLoc: metaLoc, category: .app_tools, appName: appName)
        fileHandler.createGradle(DTExerciseFinder.self, packageName: packageName, gradlePaths: gradlePaths)
    }
    
    func createPhoneValidator(appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths, resPath: String, mainData: MainData, xmlPaths: XMLLayoutPaths) {
        fileHandler.writeFile(filePath: path, contentText: DTPhoneValidator.mainFragmentCMF(mainData).content, fileName: DTPhoneValidator.mainFragmentCMF(mainData).fileName)
        fileHandler.writeFile(filePath: xmlPaths.valuesPath, contentText: DTPhoneValidatorRes.icon.content, fileName: DTPhoneValidatorRes.icon.name)
        
        fileHandler.createMeta(PhoneValidatorMeta.self, metaLoc: metaLoc, category: .app_tools, appName: appName)
        fileHandler.createGradle(DTPhoneValidator.self, packageName: packageName, gradlePaths: gradlePaths)
    }
    
    func createHistoricalEvents(appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths, resPath: String, mainData: MainData, xmlPaths: XMLLayoutPaths) {
        fileHandler.writeFile(filePath: path, contentText: DTHistoricalEvents.mainFragmentCMF(mainData).content, fileName: DTHistoricalEvents.mainFragmentCMF(mainData).fileName)
        fileHandler.writeFile(filePath: xmlPaths.valuesPath, contentText: DTHistoricalEventsRes.icon.content, fileName: DTHistoricalEventsRes.icon.name)
        
        fileHandler.createMeta(HistoricalEventsMeta.self, metaLoc: metaLoc, category: .app_tools, appName: appName)
        fileHandler.createGradle(DTHistoricalEvents.self, packageName: packageName, gradlePaths: gradlePaths)
    }
    
    func createGastronomyGuru(appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths, resPath: String, mainData: MainData, xmlPaths: XMLLayoutPaths) {
        fileHandler.writeFile(filePath: path, contentText: DTGastronomyGuru.mainFragmentCMF(mainData).content, fileName: DTGastronomyGuru.mainFragmentCMF(mainData).fileName)
        fileHandler.writeFile(filePath: xmlPaths.valuesPath, contentText: DTGastronomyGuruRes.icon.content, fileName: DTGastronomyGuruRes.icon.name)
        
        fileHandler.createMeta(GastronomyGuruMeta.self, metaLoc: metaLoc, category: .app_tools, appName: appName)
        fileHandler.createGradle(DTGastronomyGuru.self, packageName: packageName, gradlePaths: gradlePaths)
    }
    
    func createWordWise(appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths, resPath: String, mainData: MainData, xmlPaths: XMLLayoutPaths) {
        fileHandler.writeFile(filePath: path, contentText: DTWordWise.mainFragmentCMF(mainData).content, fileName: DTWordWise.mainFragmentCMF(mainData).fileName)
        fileHandler.writeFile(filePath: xmlPaths.valuesPath, contentText: DTWordWiseRes.icon.content, fileName: DTWordWiseRes.icon.name)
        
        fileHandler.createMeta(WordWiseMeta.self, metaLoc: metaLoc, category: .app_tools, appName: appName)
        fileHandler.createGradle(DTWordWise.self, packageName: packageName, gradlePaths: gradlePaths)
    }
    
}
