//
//  File.swift
//  
//
//  Created by admin on 31.10.2023.
//

import Foundation

extension KDController {
    func createGallery(appName: String, path: String, xmlPaths: XMLLayoutPaths, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths) {
        fileHandler.writeFile(filePath: path, contentText: KDGallery.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: KDGallery.fileName)
        fileHandler.createGradle(KDGallery.self, packageName: packageName, gradlePaths: gradlePaths)
        fileHandler.createMeta(RandomPhotosMeta.self, metaLoc: metaLoc, category: .app_entertainment, appName: appName)
        fileHandler.checkDirectory(atPath: xmlPaths.fontPath)
        fileHandler.copyPaste(from: LocalConst.fontDir + "/arvo_bold.ttf", to: xmlPaths.fontPath + "/arvo_bold.ttf")
        fileHandler.copyPaste(from: LocalConst.fontDir + "/lilitaone_regular.ttf", to: xmlPaths.fontPath + "/lilitaone_regular.ttf")
    }
    
    func createNamesGennerator(appName: String, path: String, xmlPaths: XMLLayoutPaths, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths, resPath: String) {
        fileHandler.writeFile(filePath: path, contentText: KDNameGenerator.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: KDNameGenerator.fileName)
        fileHandler.copyPaste(from: LocalConst.homeDir + "/GeneratorProjects/resources/bannerResources/kdnamegenerator/button_icon.png", to: resPath + "generator.png")
        fileHandler.checkDirectory(atPath: xmlPaths.fontPath)
        fileHandler.copyPaste(from: LocalConst.fontDir + "/roboto_bold.ttf", to: xmlPaths.fontPath + "/roboto_bold.ttf")
        fileHandler.copyPaste(from: LocalConst.fontDir + "/roboto_medium.ttf", to: xmlPaths.fontPath + "/roboto_medium.ttf")
        fileHandler.createGradle(KDNameGenerator.self, packageName: packageName, gradlePaths: gradlePaths)
        fileHandler.createMeta(NameGeneratorMeta.self, metaLoc: metaLoc, category: .app_entertainment, appName: appName)
    }
    
    func createNews(appName: String, path: String, xmlPaths: XMLLayoutPaths, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths) {
        fileHandler.writeFile(filePath: path, contentText: KDNews.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: KDNews.fileName)
        fileHandler.checkDirectory(atPath: xmlPaths.fontPath)
        fileHandler.copyPaste(from: LocalConst.fontDir + "/gidugu_regular.ttf", to: xmlPaths.fontPath + "/gidugu_regular.ttf")
        fileHandler.copyPaste(from: LocalConst.fontDir + "/montserrat_bold.ttf", to: xmlPaths.fontPath + "/montserrat_bold.ttf")
        fileHandler.copyPaste(from: LocalConst.fontDir + "/montserrat_semibold.ttf", to: xmlPaths.fontPath + "/montserrat_semibold.ttf")
        fileHandler.createMeta(NewsMeta.self, metaLoc: metaLoc, category: .app_tools, appName: appName)
        fileHandler.createGradle(KDNews.self, packageName: packageName, gradlePaths: gradlePaths)
    }
    
    func createFindUniversity(appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths) {
        fileHandler.writeFile(filePath: path, contentText: KDFindUniversity.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: KDFindUniversity.fileName)
        fileHandler.createGradle(KDFindUniversity.self, packageName: packageName, gradlePaths: gradlePaths)
        fileHandler.createMeta(FindUniversityMeta.self, metaLoc: metaLoc, category: .app_entertainment, appName: appName)
    }
    
    func createAssatiations(appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths) {
        fileHandler.writeFile(filePath: path, contentText: KDAssotiations.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: KDAssotiations.fileName)
        fileHandler.createMeta(AssatiationsMeta.self, metaLoc: metaLoc, category: .app_entertainment, appName: appName)
        fileHandler.createGradle(KDAssotiations.self, packageName: packageName, gradlePaths: gradlePaths)
    }
    
    func createConverter(appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths) {
        fileHandler.writeFile(filePath: path, contentText: KDConverter.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: KDConverter.fileName)
        fileHandler.createMeta(ConverterMeta.self, metaLoc: metaLoc, category: .app_tools, appName: appName)
        fileHandler.createGradle(KDConverter.self, packageName: packageName, gradlePaths: gradlePaths)
    }
    
    func createCats(appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths) {
        fileHandler.writeFile(filePath: path, contentText: KDCats.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: KDCats.fileName)
        fileHandler.createMeta(CatsMeta.self, metaLoc: metaLoc, category: .app_entertainment, appName: appName)
        fileHandler.createGradle(KDCats.self, packageName: packageName, gradlePaths: gradlePaths)
    }
    
    func createToDo(appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths) {
        fileHandler.writeFile(filePath: path, contentText: KDTodo.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: KDTodo.fileName)
        fileHandler.createMeta(ToDoListMeta.self, metaLoc: metaLoc, category: .app_tools, appName: appName)
        fileHandler.createGradle(KDTodo.self, packageName: packageName, gradlePaths: gradlePaths)
    }
    
    func createAffirmations(appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths) {
        fileHandler.writeFile(filePath: path, contentText: KDAffirmations.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: KDAffirmations.fileName)
        fileHandler.createMeta(AffirmationsMeta.self, metaLoc: metaLoc, category: .app_entertainment, appName: appName)
        fileHandler.createGradle(KDAffirmations.self, packageName: packageName, gradlePaths: gradlePaths)
    }
    
    func createNotes(appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths) {
        fileHandler.writeFile(filePath: path, contentText: KDNotes.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: KDNotes.fileName)
        fileHandler.createMeta(NotesMeta.self, metaLoc: metaLoc, category: .app_tools, appName: appName)
        fileHandler.createGradle(KDNotes.self, packageName: packageName, gradlePaths: gradlePaths)
    }

    func createPedometer(appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths, maPath: String, mainData: MainData) {
        fileHandler.writeFile(filePath: path, contentText: KDPedometer.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: KDPedometer.fileName)
        fileHandler.writeFile(filePath: maPath, contentText: KDPedometer.cmaHandler(mainData).content, fileName: KDPedometer.cmaHandler(mainData).fileName)
        fileHandler.createGradle(KDPedometer.self, packageName: packageName, gradlePaths: gradlePaths)
        fileHandler.createMeta(PedometerMeta.self, metaLoc: metaLoc, category: .app_tools, appName: appName)
    }
    

    func createExpenseTracker(appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths) {
        fileHandler.writeFile(filePath: path, contentText: KDExpenceTracker.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: KDExpenceTracker.fileName)
        fileHandler.createGradle(KDExpenceTracker.self, packageName: packageName, gradlePaths: gradlePaths)
        fileHandler.createMeta(ExpenseTrackerMeta.self, metaLoc: metaLoc, category: .app_tools, appName: appName)
    }

    func createCalculator(appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths) {
        fileHandler.writeFile(filePath: path, contentText: KDCalculator.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: KDCalculator.fileName)
        fileHandler.createMeta(CalculatorMeta.self, metaLoc: metaLoc, category: .app_tools, appName: appName)
        fileHandler.createGradle(KDCalculator.self, packageName: packageName, gradlePaths: gradlePaths)
    }
    
    func createCanvas(appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths) {
        fileHandler.writeFile(filePath: path, contentText: KDCanvas.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: KDCanvas.fileName)
        fileHandler.createMeta(CanvasMeta.self, metaLoc: metaLoc, category: .game_arcade, appName: appName)
        fileHandler.createGradle(KDCanvas.self, packageName: packageName, gradlePaths: gradlePaths)
    }
    
    func createComposeQuiz(appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths, resPath: String) {
        fileHandler.writeFile(filePath: path, contentText: KDComposeQuiz.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: KDComposeQuiz.fileName)
        fileHandler.createMeta(QuizMeta.self, metaLoc: metaLoc, category: .app_entertainment, appName: appName)
        fileHandler.createGradle(KDComposeQuiz.self, packageName: packageName, gradlePaths: gradlePaths)
        fileHandler.copyPaste(from: "/Users/admin/GeneratorProjects/resources/bannerResources/kdcomposequiz/lifecycle_1_image.webp", to: resPath + "lifecycle_1_image.webp")
        fileHandler.copyPaste(from: "/Users/admin/GeneratorProjects/resources/bannerResources/kdcomposequiz/jetpack_compose_img.webp", to: resPath + "jetpack_compose_img.webp")
    }
    
    func createTopFilms(appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths) {
        fileHandler.writeFile(filePath: path, contentText: KDTopFilms.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: KDTopFilms.fileName)
        fileHandler.createMeta(FilmsAPIMeta.self, metaLoc: metaLoc, category: .app_entertainment, appName: appName)
        fileHandler.createGradle(KDTopFilms.self, packageName: packageName, gradlePaths: gradlePaths)
    }
    
    func createRandomDogs(appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths) {
        fileHandler.writeFile(filePath: path, contentText: KDRandomDogs.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: KDRandomDogs.fileName)
        fileHandler.createMeta(RandomDogsMeta.self, metaLoc: metaLoc, category: .app_entertainment, appName: appName)
        fileHandler.createGradle(KDRandomDogs.self, packageName: packageName, gradlePaths: gradlePaths)
    }
    
    func createRandomText(appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths) {
        fileHandler.writeFile(filePath: path, contentText: KDRandomText.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: KDRandomText.fileName)
        fileHandler.createMeta(RandomTextMeta.self, metaLoc: metaLoc, category: .app_entertainment, appName: appName)
        fileHandler.createGradle(KDRandomText.self, packageName: packageName, gradlePaths: gradlePaths)
    }
    
    func createSearchMusic(appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths) {
        fileHandler.writeFile(filePath: path, contentText: KDSearchMusic.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: KDSearchMusic.fileName)
        fileHandler.createMeta(SearchMusicMeta.self, metaLoc: metaLoc, category: .app_entertainment, appName: appName)
        fileHandler.createGradle(KDSearchMusic.self, packageName: packageName, gradlePaths: gradlePaths)

    }
}
