//
//  File.swift
//  
//
//  Created by admin on 01.06.2023.
//

import Foundation
import SwiftUI

class FileHandler: ObservableObject {
    
    @Published var processingState: FileHandlerState = .none
    @Published var errorExist = false
    @Published var errorMessage = ""

    
    func readFile(filePath: String) -> FileContent {
        if FileManager.default.fileExists(atPath: filePath) {
            do {
                let content = try String(contentsOf:  URL.init(filePath: filePath), encoding: .utf8)
                guard let package = content.components(separatedBy: CharacterSet.newlines).first else {
                    return FileContent.emptyFile()
                }
                guard let fileName = filePath.split(separator: "/").last else {
                    return FileContent.emptyFile()
                }
                self.processingState = .success
                return FileContent(
                    fileName: String(fileName),
                    fullPackage: package.replacing("package ", with: "").trimmingCharacters(in: .whitespacesAndNewlines),
                    content: content, usable: true
                )
            } catch {
                return FileContent.emptyFile()
            }
        } else {
            return FileContent.emptyFile()
        }
    }
    
    func checkContains(_ name: String) -> Bool {
        let ext = [".kt", ".xml", ".gradle", ".properties", ".pro"]
        if ext.filter({ name.contains($0) }).count > 0 {
            return true
        } else {
            return false
        }
    }
    
    func readAllFiles(path: String) -> [String] {
        
        do {
            let names = try FileManager.default.contentsOfDirectory(atPath: path)
            var list: [String] = []
            for item in names {
                if checkContains(item) {
                    list.append(path + item)
                }
            }
            return list
        } catch {
            return []
        }

    }
    
    func writeFile(filePath: String, contentText: String, fileName: String) {
        if !FileManager.default.fileExists(atPath: filePath) {
            do {
                try FileManager.default.createDirectory(atPath: filePath, withIntermediateDirectories: true)
                FileManager.default.createFile(atPath: filePath, contents: nil, attributes: nil)
                try contentText.write(to: URL.init(filePath: filePath + fileName), atomically: false, encoding: .utf8)
            } catch {
//                errorManage(message: error.localizedDescription)
            }
        } else {
            do {
                FileManager.default.createFile(atPath: filePath, contents: nil, attributes: nil)
                try contentText.write(to: URL.init(filePath: filePath + fileName), atomically: false, encoding: .utf8)
//                DispatchQueue.main.async {
//                    self.processingState = .success
//                }
            } catch {
//                errorManage(message: error.localizedDescription)
            }
        }
    }
    
    func readDirectory(path: String) -> [FileContent] {
//        publishersInit()
        guard let paths = FileManager.default.subpaths(atPath: path) else {
//            errorManage(message: "Error: No paths found")
            return []
        }
        var filesList: [FileContent] = []
        for p in paths {
            if p.contains(".kt") || p.contains(".xml") || p.contains(".kts") || p.contains(".pro") {
                let content = self.readFile(filePath: "\(path)/\(p)")
                filesList.append(content)
            }
        }
        self.processingState = .success
        return filesList
    }
    
    func deleteFile(filePath: String) {
//        publishersInit()
        if FileManager.default.fileExists(atPath: filePath) {
            do {
                try FileManager.default.removeItem(atPath: filePath)
//                DispatchQueue.main.async {
//                    self.processingState = .success
//                }
                
            } catch {
//                errorManage(message: error.localizedDescription)
            }
        }
    }
    
    func copyPaste(from fromPath: String, to toPath: String) {
//        publishersInit()
        do {
            try FileManager.default.copyItem(at: URL.init(filePath: fromPath), to: URL.init(filePath: toPath))
            self.processingState = .success
        } catch {
            print(error)
//            errorManage(message: error.localizedDescription)
        }
    }
    
    func createGradle<T: FileProviderProtocol>(_ provider: T.Type, packageName: String, gradlePaths: GradlePaths) {
        
        writeFile(filePath: gradlePaths.projectGradlePath, contentText: provider.gradle(packageName).projectBuildGradle.content, fileName: provider.gradle(packageName).projectBuildGradle.name)
        writeFile(filePath: gradlePaths.moduleGradlePath, contentText: provider.gradle(packageName).moduleBuildGradle.content, fileName: provider.gradle(packageName).moduleBuildGradle.name)
        writeFile(filePath: gradlePaths.dependenciesPath, contentText: provider.gradle(packageName).dependencies.content, fileName: provider.gradle(packageName).dependencies.name)
    }
    
//    func reset() {
//        self.processingState = .none
//        self.errorExist = false
//        self.errorMessage = ""
//    }
//
//    func errorManage(message: String) {
//        DispatchQueue.main.async {
//            self.processingState = .failure
//            self.errorExist = true
//            self.errorMessage = message
//        }
//
//    }
//
//    func publishersInit() {
//        DispatchQueue.main.async {
//            self.processingState = .processing
//            self.errorExist = false
//            self.errorMessage = ""
//        }
//
//    }
    
    func createFile(
        destination: String,
        fileName: String,
        replace: [ReplaceData],
        content: String
    ) {
        var temp = content
        replace.forEach { item in
            temp = temp.replacing(item.oldValue, with: item.newValue)
        }
        self.writeFile(filePath: destination, contentText: temp, fileName: fileName)
    }
}
