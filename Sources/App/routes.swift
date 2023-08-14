import Fluent
import Vapor
import CoreMedia
import SwiftUI

func routes(_ app: Application) throws {
    
    @ObservedObject var fileHandler = FileHandler()
    
    let core = CoreController(fileHandler: fileHandler)
    
    try app.register(collection: core)
}

