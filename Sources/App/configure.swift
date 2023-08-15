import NIOSSL
import Fluent
import FluentPostgresDriver
import Leaf
import Vapor

// configures your application
public func configure(_ app: Application) async throws {
    
//    app.databases.use(.postgres(configuration: SQLPostgresConfiguration(
//        hostname: Environment.get("DATABASE_HOST") ?? "localhost",
//        port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? SQLPostgresConfiguration.ianaPortNumber,
//        username: Environment.get("DATABASE_USERNAME") ?? "vapor_username",
//        password: Environment.get("DATABASE_PASSWORD") ?? "vapor_password",
//        database: Environment.get("DATABASE_NAME") ?? "vapor_database",
//        tls: .prefer(try .init(configuration: .clientDefault)))
//    ), as: .psql)
    
//    app.migrations.add(CreateDBLogModel())
//
//    app.logger.logLevel = .debug
    
    app.databases.use(.postgres(configuration: SQLPostgresConfiguration(hostname: "batyr.db.elephantsql.com", username: "rsxjookb", password: "EfH7r4Ffpv0l61t06mQOEQrvEBjLP0Br", database: "rsxjookb", tls: .prefer(try .init(configuration: .clientDefault)))), as: .psql)
    
    app.migrations.add(CreateDBLogMigrator())
    
    try routes(app)
}
