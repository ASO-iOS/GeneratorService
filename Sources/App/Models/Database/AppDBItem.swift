//
//  File.swift
//  
//
//  Created by admin on 28.06.2023.
//

import Fluent
import Vapor
import FluentPostgresDriver

final class AppDBItem: Model, Content {
    static let schema = "app_item"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "file_name")
    var fileName: String
    
    @Field(key: "file_text")
    var fileContent: String
}
