//
//  File.swift
//  
//
//  Created by admin on 26.05.2023.
//

import Foundation

struct AndroidAppApplication {
    static func fileContent(packageName: String, applicationName: String, appId: String) -> String {
        let data = transferById(appId, packageName: packageName)
        return """
package \(packageName).application

import android.app.Application
import dagger.hilt.android.HiltAndroidApp
\(data.imports)

@HiltAndroidApp
class \(applicationName) : Application()
\(data.content)
"""
    }
    
    static func transferById(_ appId: String, packageName: String) -> ApplicationDataTransfer {
        switch appId {
        case AppIDs.VE_RECIPES_BOOK:
            return .init(imports: """
import \(packageName).presentation.fragments.main_fragment.dataModule
import \(packageName).presentation.fragments.main_fragment.useCaseModule
import \(packageName).presentation.fragments.main_fragment.viewModelModule
import org.koin.android.ext.koin.androidContext
import org.koin.android.ext.koin.androidLogger
import org.koin.core.context.startKoin
""", content: """
{
    override fun onCreate() {
        super.onCreate()

        startKoin {
            androidLogger()
            androidContext(this@Application)
            modules(dataModule, viewModelModule, useCaseModule)
        }
    }
}
""")
        case AppIDs.BC_NAME_GENERATOR:
            return .init(imports: """
import android.content.Context
""", content: """
 {
    override fun onCreate() {
        super.onCreate()
        context = this
    }

    companion object {
        var context: Context? = null
            private set
    }
}
""")
        case AppIDs.EA_REMINDER:
            return .init(
                imports: """
import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.Context
import android.os.Build
import \(packageName).R
import \(packageName).presentation.fragments.main_fragment.ReminderNotificationService
""",
                content: """
{

    override fun onCreate() {
        super.onCreate()
        createNotificationChannel()
    }

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                ReminderNotificationService.NOTIFICATION_CHANNEL_ID,
                ReminderNotificationService.NOTIFICATION_CHANNEL_NAME,
                NotificationManager.IMPORTANCE_HIGH
            )
            channel.description = getString(R.string.channel_description)

            val notificationManager =
                getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            notificationManager.createNotificationChannel(channel)
        }
    }
}
"""
            )
            
        default: return .empty
        }
    }
    
}

struct ApplicationDataTransfer {
    let imports: String
    let content: String
    
    static var empty: ApplicationDataTransfer {
        ApplicationDataTransfer(imports: "", content: "")
    }
}
