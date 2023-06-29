import Fluent
import Vapor
import CoreMedia
import SwiftUI

func routes(_ app: Application) throws {
//    app.get("image") { req in
//        let filePath = "/Users/admin/Desktop/waa.jpg"
//        let fileUrl = URL(fileURLWithPath: filePath)
//                    let data = try Data(contentsOf: fileUrl)
//        let imm = ContentContainer()
//        let response: Response = req.content.
////        return response
//                let file = req.fileio.streamFile(at: "/Users/admin/Desktop/PingTool.zip")
//                return file
////        do {
////        }
//    }
//    app.get("file") { req in
//        let file = req.fileio.streamFile(at: "/Users/admin/Desktop/ball.zip")
//        return file
//    }
    
//    func mm(_ request: Request) throws -> Response {
//
//    }
    @ObservedObject var fileHandler = FileHandler()
    let core = CoreController(fileHandler: fileHandler)
    try app.register(collection: core)
//    try utilRoute(app, fileHandler: fileHandler)
//    try coreAppRoute(app, fileHandler: fileHandler)
//    try v1AppRoute(app, fileHandler: fileHandler)
//    try app.register(collection: TodoController())
}

