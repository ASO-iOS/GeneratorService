//
//  File.swift
//  
//
//  Created by admin on 26.05.2023.
//

import Foundation

struct AndroidAppMainActivity {
    static func fileContent(packageName: String, appId: String, mainData: MainData) -> String {
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
\(AndroidNecesseryDependencies.dependencies(mainData).mainActivityData.imports)

@AndroidEntryPoint
class MainActivity : AppCompatActivity() {

    private val binding by lazy { MainActivityScreen(this).create() }
    private val viewModel by viewModels<StateViewModel>()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        \(AndroidNecesseryDependencies.dependencies(mainData).mainActivityData.extraFunc)
        setContentView(binding.container)
        lifecycleScope.launch {
            repeatOnLifecycle(Lifecycle.State.CREATED) {
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

    \(AndroidNecesseryDependencies.dependencies(mainData).mainActivityData.content)
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
}
