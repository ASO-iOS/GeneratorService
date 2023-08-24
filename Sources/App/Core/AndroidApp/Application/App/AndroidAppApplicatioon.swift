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
import com.vagavagusdevelop.recipesbookpro.presentation.fragments.main_fragment.dataModule
import com.vagavagusdevelop.recipesbookpro.presentation.fragments.main_fragment.useCaseModule
import com.vagavagusdevelop.recipesbookpro.presentation.fragments.main_fragment.viewModelModule
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
