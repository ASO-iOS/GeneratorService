//
//  File.swift
//  
//
//  Created by admin on 09.08.2023.
//

import Foundation

extension AKController {
    func createRickAndMorty(appName: String, path: String, resPath: String, xmlPaths: XMLLayoutPaths, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths) {
        fileHandler.writeFile(filePath: path, contentText: AKRickAndMorty.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: AKRickAndMorty.fileName)
        fileHandler.writeFile(filePath: path, contentText: AKRickAndMorty.cmfHandler(packageName).content, fileName: AKRickAndMorty.cmfHandler(packageName).fileName)
        fileHandler.copyPaste(from: "\(LocalConst.homeDir)GeneratorProjects/resources/images/akrickandmorty/arrow_next.png", to: resPath + "arrow_next.png")
        fileHandler.copyPaste(from: "\(LocalConst.homeDir)GeneratorProjects/resources/images/akrickandmorty/arrow_back.png", to: resPath + "arrow_back.png")
        fileHandler.copyPaste(from: "\(LocalConst.homeDir)GeneratorProjects/resources/images/akrickandmorty/arrow.png", to: resPath + "arrow.png")
        fileHandler.copyPaste(from: "\(LocalConst.homeDir)GeneratorProjects/resources/images/akrickandmorty/logo.png", to: resPath + "logo.png")
        fileHandler.checkDirectory(atPath: xmlPaths.fontPath)
        fileHandler.copyPaste(from: "\(LocalConst.homeDir)GeneratorProjects/resources/font/gilroy_bold.ttf", to: xmlPaths.fontPath + "gilroy_bold.ttf")
        fileHandler.copyPaste(from: "\(LocalConst.homeDir)GeneratorProjects/resources/font/gilroy_medium.ttf", to: xmlPaths.fontPath + "gilroy_medium.ttf")
        fileHandler.copyPaste(from: "\(LocalConst.homeDir)GeneratorProjects/resources/font/gilroy.otf", to: xmlPaths.fontPath + "gilroy.otf")
        fileHandler.writeFile(filePath: resPath, contentText: AKRickAndMortyRes.content, fileName: AKRickAndMortyRes.name)
        fileHandler.createMeta(CartoonCharactersMeta.self, metaLoc: metaLoc, category: .app_entertainment, appName: appName)
        fileHandler.createGradle(AKRickAndMorty.self, packageName: packageName, gradlePaths: gradlePaths)
    }
    
    func createShashlikCalculator(appName: String, path: String, resPath: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths) {
        fileHandler.writeFile(filePath: path, contentText: AKShahlikCalculator.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: AKShahlikCalculator.fileName)
        fileHandler.copyPaste(from: "\(LocalConst.homeDir)GeneratorProjects/resources/images/akshashlikcalculator/chicken.webp", to: resPath + "chicken.webp")
        fileHandler.copyPaste(from: "\(LocalConst.homeDir)GeneratorProjects/resources/images/akshashlikcalculator/cow.webp", to: resPath + "cow.webp")
        fileHandler.copyPaste(from: "\(LocalConst.homeDir)GeneratorProjects/resources/images/akshashlikcalculator/pig.webp", to: resPath + "pig.webp")
        fileHandler.copyPaste(from: "\(LocalConst.homeDir)GeneratorProjects/resources/images/akshashlikcalculator/shashlik.webp", to: resPath + "shashlik.webp")
        fileHandler.copyPaste(from: "\(LocalConst.homeDir)GeneratorProjects/resources/images/akshashlikcalculator/sheep.webp", to: resPath + "sheep.webp")
        fileHandler.createMeta(ShashlikCalculatorMeta.self, metaLoc: metaLoc, category: .app_entertainment, appName: appName)
        fileHandler.createGradle(AKShahlikCalculator.self, packageName: packageName, gradlePaths: gradlePaths)
    }
    
    func createAlarm(appName: String, path: String, resPath: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths) {
        fileHandler.writeFile(filePath: path, contentText: AKAlarm.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: AKAlarm.fileName)
        fileHandler.writeFile(filePath: resPath, contentText: AKAlarmRes.content(uiSettings.textColorPrimary ?? "FFFFFF"), fileName: AKAlarmRes.name)
        fileHandler.createMeta(AlarmMeta.self, metaLoc: metaLoc, category: .app_tools, appName: appName)
        fileHandler.createGradle(AKAlarm.self, packageName: packageName, gradlePaths: gradlePaths)
    }
    
    func createToDo(appName: String, path: String, resPath: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths) {
        fileHandler.writeFile(filePath: path, contentText: AKToDo.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: AKToDo.fileName)
        fileHandler.copyPaste(from: LocalConst.homeDir + "GeneratorProjects/resources/bannerResources/aktodo/add_button.png", to: resPath + "add_button.png")
        fileHandler.copyPaste(from: LocalConst.homeDir + "GeneratorProjects/resources/bannerResources/aktodo/main_img.png", to: resPath + "main_img.png")
        fileHandler.copyPaste(from: LocalConst.homeDir + "GeneratorProjects/resources/bannerResources/aktodo/trash.png", to: resPath + "trash.png")
        fileHandler.createMeta(ToDoListMeta.self, metaLoc: metaLoc, category: .app_tools, appName: appName)
        fileHandler.createGradle(AKToDo.self, packageName: packageName, gradlePaths: gradlePaths)
    }
    
    func createBoilingEgg(appName: String, path: String, resPath: String, xmlPaths: XMLLayoutPaths, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths) {
        fileHandler.writeFile(filePath: path, contentText: AKBoilingEgg.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: AKBoilingEgg.fileName)
        fileHandler.copyPaste(from: LocalConst.homeDir + "GeneratorProjects/resources/bannerResources/akboilingegg/background_image.webp", to: resPath + "background_image.webp")
        fileHandler.copyPaste(from: LocalConst.homeDir + "GeneratorProjects/resources/bannerResources/akboilingegg/play_icon.png", to: resPath + "play_icon.png")
        fileHandler.checkDirectory(atPath: xmlPaths.fontPath)
        fileHandler.copyPaste(from: LocalConst.homeDir + "GeneratorProjects/resources/font/bold_halvar_breit.ttf", to: xmlPaths.fontPath + "bold_halvar_breit.ttf")
        fileHandler.copyPaste(from: LocalConst.homeDir + "GeneratorProjects/resources/font/main_halvar_breit.ttf", to: xmlPaths.fontPath + "main_halvar_breit.ttf")
        fileHandler.createMeta(BoilingEggMeta.self, metaLoc: metaLoc, category: .app_tools, appName: appName)
        fileHandler.createGradle(AKBoilingEgg.self, packageName: packageName, gradlePaths: gradlePaths)
    }
    
    func createColorConverter(appName: String, path: String, resPath: String, xmlPaths: XMLLayoutPaths, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths) {
        fileHandler.writeFile(filePath: path, contentText: AKColorConverter.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: AKColorConverter.fileName)
        fileHandler.checkDirectory(atPath: xmlPaths.fontPath)
        fileHandler.copyPaste(from: LocalConst.homeDir + "GeneratorProjects/resources/font/brainstorm_marker.ttf", to: xmlPaths.fontPath + "brainstorm_marker.ttf")
        fileHandler.copyPaste(from: LocalConst.homeDir + "GeneratorProjects/resources/font/brainstorm_rollerball.ttf", to: xmlPaths.fontPath + "brainstorm_rollerball.ttf")
        fileHandler.createMeta(ColorConverterMeta.self, metaLoc: metaLoc, category: .app_tools, appName: appName)
        fileHandler.createGradle(AKColorConverter.self, packageName: packageName, gradlePaths: gradlePaths)
    }
    
    func createNewYearCountdown(appName: String, path: String, resPath: String, xmlPaths: XMLLayoutPaths, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths) {
        fileHandler.writeFile(filePath: path, contentText: AKNewYearCountdowm.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: AKNewYearCountdowm.fileName)
        fileHandler.checkDirectory(atPath: xmlPaths.fontPath)
        fileHandler.copyPaste(from: LocalConst.homeDir + "GeneratorProjects/resources/font/main_font.ttf", to: xmlPaths.fontPath + "main_font.ttf")
        fileHandler.createMeta(NewYearCountMeta.self, metaLoc: metaLoc, category: .app_tools, appName: appName)
        fileHandler.createGradle(AKNewYearCountdowm.self, packageName: packageName, gradlePaths: gradlePaths)
    }
    
    func createUVProtect(appName: String, path: String, resPath: String, xmlPaths: XMLLayoutPaths, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths) {
        fileHandler.writeFile(filePath: path, contentText: AKUVProtect.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: AKUVProtect.fileName)
        fileHandler.checkDirectory(atPath: xmlPaths.fontPath)
        fileHandler.copyPaste(from: LocalConst.homeDir + "GeneratorProjects/resources/font/unbounded_font.ttf", to: xmlPaths.fontPath + "unbounded_font.ttf")
        fileHandler.copyPaste(from: LocalConst.homeDir + "GeneratorProjects/resources/font/unbounded_normal_font.ttf", to: xmlPaths.fontPath + "unbounded_normal_font.ttf")
        fileHandler.copyPaste(from: LocalConst.homeDir + "GeneratorProjects/resources/bannerResources/akuvprotect/bg_colors_image.webp", to: resPath + "bg_colors_image.webp")
        fileHandler.copyPaste(from: LocalConst.homeDir + "GeneratorProjects/resources/bannerResources/akuvprotect/uv_index_logo.webp", to: resPath + "uv_index_logo.webp")
        fileHandler.createMeta(UVProtectMeta.self, metaLoc: metaLoc, category: .app_tools, appName: appName)
        fileHandler.createGradle(AKUVProtect.self, packageName: packageName, gradlePaths: gradlePaths)
    }
    
    func createRGBConverter(appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths) {
        fileHandler.writeFile(filePath: path, contentText: AKRGBConverter.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: AKRGBConverter.fileName)
        fileHandler.createMeta(RGBConverterMeta.self, metaLoc: metaLoc, category: .app_tools, appName: appName)
        fileHandler.createGradle(AKRGBConverter.self, packageName: packageName, gradlePaths: gradlePaths)
    }
    
    func createRetrogradeMercury(appName: String, path: String, resPath: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths) {
        fileHandler.writeFile(filePath: path, contentText: AKRetrogradeMercury.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: AKRetrogradeMercury.fileName)
        fileHandler.copyPaste(from: LocalConst.homeDir + "GeneratorProjects/resources/bannerResources/akretrogrademercury/background_image.webp", to: resPath + "background_image.webp")
        fileHandler.createMeta(RetrogradeMercuryMeta.self, metaLoc: metaLoc, category: .app_tools, appName: appName)
        fileHandler.createGradle(AKRetrogradeMercury.self, packageName: packageName, gradlePaths: gradlePaths)
    }
    
    func createRandomJoke(appName: String, path: String, xmlPaths: XMLLayoutPaths, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths) {
        fileHandler.writeFile(filePath: path, contentText: AKRandomJoke.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: AKRandomJoke.fileName)
        fileHandler.checkDirectory(atPath: xmlPaths.fontPath)
        fileHandler.copyPaste(from: LocalConst.homeDir + "GeneratorProjects/resources/font/brutalistmono.ttf", to: xmlPaths.fontPath + "brutalistmono.ttf")
        fileHandler.copyPaste(from: LocalConst.homeDir + "GeneratorProjects/resources/font/howlimit.ttf", to: xmlPaths.fontPath + "howlimit.ttf")
        fileHandler.createMeta(RandomJokeMeta.self, metaLoc: metaLoc, category: .app_tools, appName: appName)
        fileHandler.createGradle(AKRandomJoke.self, packageName: packageName, gradlePaths: gradlePaths)
    }
    
    func createCartoonLocations(appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths) {
        fileHandler.writeFile(filePath: path, contentText: AKCartoonLocations.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: AKCartoonLocations.fileName)
        fileHandler.createMeta(CartoonLocationsMeta.self, metaLoc: metaLoc, category: .app_entertainment, appName: appName)
        fileHandler.createGradle(AKCartoonLocations.self, packageName: packageName, gradlePaths: gradlePaths)
    }
    
    func createFruits(appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths) {
        fileHandler.writeFile(filePath: path, contentText: AKFruits.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: AKFruits.fileName)
        fileHandler.createMeta(FruitsMeta.self, metaLoc: metaLoc, category: .app_tools, appName: appName)
        fileHandler.createGradle(AKFruits.self, packageName: packageName, gradlePaths: gradlePaths)
    }
    
    func createPokerChances(appName: String, path: String, resPath: String, xmlPaths: XMLLayoutPaths, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths) {
        fileHandler.writeFile(filePath: path, contentText: AKPokerChances.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: AKPokerChances.fileName)
        AKPokerChances.images.forEach { name in
            fileHandler.copyPaste(from: LocalConst.homeDir + "GeneratorProjects/resources/bannerResources/akpokerchances/\(name)", to: resPath + name)
        }
        fileHandler.checkDirectory(atPath: xmlPaths.libsPath)
        fileHandler.copyPaste(from: LocalConst.homeDir + "GeneratorProjects/resources/bannerResources/akpokerchances/PokerCalculator.jar", to: xmlPaths.libsPath + "PokerCalculator.jar")
        fileHandler.createMeta(PokerChansesMeta.self, metaLoc: metaLoc, category: .app_tools, appName: appName)
        fileHandler.createGradle(AKPokerChances.self, packageName: packageName, gradlePaths: gradlePaths)
    }
    
    func createRandomCoffee(appName: String, path: String, resPath: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths) {
        fileHandler.writeFile(filePath: path, contentText: AKRandomCoffee.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: AKRandomCoffee.fileName)
        fileHandler.writeFile(filePath: resPath, contentText: AKRandomCoffeeRes.errorOutlineContent, fileName: AKRandomCoffeeRes.errorOutlineName)
        fileHandler.writeFile(filePath: resPath, contentText: AKRandomCoffeeRes.imageContent, fileName: AKRandomCoffeeRes.imageName)
        fileHandler.createMeta(RandomCoffeeMeta.self, metaLoc: metaLoc, category: .app_tools, appName: appName)
        fileHandler.createGradle(AKRandomCoffee.self, packageName: packageName, gradlePaths: gradlePaths)
    }
    
    func createClicker(appName: String, path: String, resPath: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths) {
        fileHandler.writeFile(filePath: path, contentText: AKClicker.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: AKClicker.fileName)
        fileHandler.createMeta(ClickerMeta.self, metaLoc: metaLoc, category: .game_arcade, appName: appName)
        fileHandler.createGradle(AKClicker.self, packageName: packageName, gradlePaths: gradlePaths)
    }
    
    func createDarts(appName: String, path: String, resPath: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths) {
        fileHandler.writeFile(filePath: path, contentText: AKDarts.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: AKDarts.fileName)
        fileHandler.createMeta(DartsMeta.self, metaLoc: metaLoc, category: .game_arcade, appName: appName)
        fileHandler.createGradle(AKDarts.self, packageName: packageName, gradlePaths: gradlePaths)
    }
    
    func createSpaceAttacker(appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths) {
        fileHandler.writeFile(filePath: path, contentText: AKSpaceAttacker.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: AKSpaceAttacker.fileName)
        fileHandler.createMeta(SpaceshipAdventureMeta.self, metaLoc: metaLoc, category: .game_arcade, appName: appName)
        fileHandler.createGradle(AKSpaceAttacker.self, packageName: packageName, gradlePaths: gradlePaths)
    }
    
    func createQuiz(appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths) {
        fileHandler.writeFile(filePath: path, contentText: AKQuiz.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: AKQuiz.fileName)
        fileHandler.createMeta(QuizMeta.self, metaLoc: metaLoc, category: .game_puzzle, appName: appName)
        fileHandler.createGradle(AKQuiz.self, packageName: packageName, gradlePaths: gradlePaths)
    }
    
    func createMythologyQuiz(appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths) {
        fileHandler.writeFile(filePath: path, contentText: AKMMythologyQuiz.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: AKMMythologyQuiz.fileName)
        fileHandler.createMeta(QuizMeta.self, metaLoc: metaLoc, category: .game_puzzle, appName: appName)
        fileHandler.createGradle(AKMMythologyQuiz.self, packageName: packageName, gradlePaths: gradlePaths)
    }
    
    func createDodger(appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths) {
        fileHandler.writeFile(filePath: path, contentText: AKDodger.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: AKDodger.fileName)
        
        fileHandler.createMeta(CatcherMeta.self, metaLoc: metaLoc, category: .game_arcade, appName: appName)
        fileHandler.createGradle(AKDodger.self, packageName: packageName, gradlePaths: gradlePaths)
    }
    
    func createFrogClicker(appName: String, path: String, resPath: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths) {
        fileHandler.writeFile(filePath: path, contentText: AKClickerFrog.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: AKClickerFrog.fileName)
        fileHandler.writeFile(filePath: resPath, contentText: AKClickerFrogRes.restartBtn.content, fileName: AKClickerFrogRes.restartBtn.name)
        fileHandler.createMeta(ClickerMeta.self, metaLoc: metaLoc, category: .game_arcade, appName: appName)
        fileHandler.createGradle(AKClickerFrog.self, packageName: packageName, gradlePaths: gradlePaths)
    }
    
    func createSpaceAttacker2(appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths) {
        fileHandler.writeFile(filePath: path, contentText: AKSpaceAttacker2.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: AKSpaceAttacker2.fileName)
        fileHandler.createMeta(SpaceshipAdventureMeta.self, metaLoc: metaLoc, category: .game_arcade, appName: appName)
        fileHandler.createGradle(AKSpaceAttacker2.self, packageName: packageName, gradlePaths: gradlePaths)
    }
}
