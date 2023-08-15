//
//  File.swift
//  
//
//  Created by admin on 15.08.2023.
//

import Foundation
import Fluent

struct CreateDBLogMigrator: AsyncMigration {
    func prepare(on database: FluentKit.Database) async throws {
        try await database.schema("log_model")
            .id()
            .field("app_id", .string, .required)
            .field("stam", .string, .required)
            .create()
    }
    
    func revert(on database: Database) async throws {
        try await database.schema("log_model").delete()
    }
}
