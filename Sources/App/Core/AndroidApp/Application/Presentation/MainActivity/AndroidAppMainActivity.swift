//
//  File.swift
//  
//
//  Created by admin on 26.05.2023.
//

import Foundation

struct AndroidAppMainActivity {
    static func fileText(packageName: String, appId: String) -> String {
        return """
package \(packageName).presentation.main_activity

import android.os.Bundle
import androidx.activity.viewModels
import androidx.appcompat.app.AppCompatActivity
import androidx.fragment.app.Fragment
import androidx.fragment.app.commit
import androidx.lifecycle.lifecycleScope
import \(packageName).presentation.fragments.main_fragment.MainFragment
import \(packageName).repository.state.FragmentState
import \(packageName).repository.state.StateViewModel
import dagger.hilt.android.AndroidEntryPoint
import android.content.Context
import android.view.ViewGroup
import android.widget.FrameLayout
import androidx.fragment.app.FragmentContainerView
import androidx.lifecycle.Lifecycle
import androidx.lifecycle.repeatOnLifecycle
import kotlinx.coroutines.launch
import javax.inject.Inject
\(importById(appId, packageName))

@AndroidEntryPoint
class MainActivity : AppCompatActivity() {

    private val binding by lazy { MainActivityScreen(this).create() }
    private val viewModel by viewModels<StateViewModel>()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        \(extraFunc(appId))
        setContentView(binding.container)
        lifecycleScope.launch {
            repeatOnLifecycle(Lifecycle.State.STARTED) {
                viewModel.state.collect {
                    when(it) {
                        is FragmentState.MainState -> replace(MainFragment())
                    }
                }
            }
        }
    }

    private fun replace(fragment: Fragment) {
        supportFragmentManager.commit(allowStateLoss = true) {
            setReorderingAllowed(true)
            replace(MainActivityScreen.CONTAINER_ID, fragment)
        }
    }

    \(addById(appId))
}

class MainActivityScreen @Inject constructor(private val context: Context) {
    lateinit var container: FragmentContainerView

    companion object {
        const val CONTAINER_ID = 1
    }

    fun create(): MainActivityScreen {
        container = FragmentContainerView(context).apply {
            layoutParams = FrameLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT,
                ViewGroup.LayoutParams.MATCH_PARENT
            )
            id = CONTAINER_ID
        }
        return this
    }
}
"""
    }
    
    static func addById(_ id: String) -> String {
        switch id {
        case AppIDs.MB_RACE, AppIDs.MB_CATCHER:
            return """
    private fun initInset() {
        WindowCompat.setDecorFitsSystemWindows(window, false)

        val statusBarHeight: Int
        val navigationBarHeight: Int

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
            val insets = windowManager.currentWindowMetrics.windowInsets
            statusBarHeight = insets.getInsets(WindowInsetsCompat.Type.statusBars()).top
            navigationBarHeight =
                insets.getInsets(WindowInsetsCompat.Type.navigationBars()).bottom
        } else {
            val rect = Rect()
            window.decorView.getWindowVisibleDisplayFrame(rect)

            statusBarHeight = rect.top
            navigationBarHeight = screenHeight - rect.top - rect.height()
        }

        insetScreenHeight = screenHeight + statusBarHeight + navigationBarHeight
    }
"""
        default:
            return ""
        }
    }
    
    static func importById(_ id: String, _ packageName: String) -> String {
        switch id {
        case AppIDs.MB_RACE, AppIDs.MB_CATCHER:
            return """
import androidx.core.view.WindowCompat
import androidx.core.view.WindowInsetsCompat
import android.graphics.Rect
import android.os.Build
import \(packageName).presentation.fragments.main_fragment.BitmapsInitializer.Companion.insetScreenHeight
import \(packageName).presentation.fragments.main_fragment.BitmapsInitializer.Companion.screenHeight
"""

        default:
            return ""
        }
    }
    
    static func extraFunc(_ id: String) -> String {
        switch id {
        case AppIDs.MB_RACE, AppIDs.MB_CATCHER:
            return """
        initInset()
"""
        default:
            return ""
        }
    }
    
}
