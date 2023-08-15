//
//  File.swift
//  
//
//  Created by admin on 28.06.2023.
//

import Fluent
import Vapor
import FluentPostgresDriver

final class DBLogModel: Model, Content {
    static let schema = "log_model"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "app_id")
    var appID: String
    
    @Field(key: "stam")
    var stam: String
    
//    @Field(key: "date")
//    var date: String
    
    init() {}
    init(id: UUID? = nil, appId: String, stam: String) {
        self.id = id
        self.appID = appID
        self.stam = stam
//        self.date = date
    }
}

//struct DBLogDTO: Decodable {
//    var appId: String?
//    var date: Date?
//}
//
//struct CreateDBLogModel: Migration {
//    
//    func prepare(on database: Database) -> EventLoopFuture<Void> {
//        database.schema("log_model")
//            .id()
//            .field("app_id", .string, .required)
//            .field("date", .date)
//            .create()
//    }
//
//    func revert(on database: Database) -> EventLoopFuture<Void> {
//        database.schema("log_model").delete()
//    }
//}
