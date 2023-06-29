//
//  File.swift
//  
//
//  Created by admin on 20.06.2023.
//

import Foundation

struct MBIpCheckerMainActivity {
    static let fileName = "MainActivity.kt"
    static func fileText(packageName: String) -> String {
        return """
        package \(packageName).presentation.main_activity
        
        import android.os.Bundle
        import androidx.appcompat.app.AppCompatActivity
        import androidx.navigation.NavController
        import androidx.navigation.Navigation
        import \(packageName).R
        import \(packageName).databinding.ActivityMainBinding
        import dagger.hilt.android.AndroidEntryPoint
        
        @AndroidEntryPoint
        class MainActivity : AppCompatActivity() {
        
        private var _binding: ActivityMainBinding? = null
        private val binding get() = _binding!!
        
        private var navController: NavController? = null
        
        override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        _binding = ActivityMainBinding.inflate(layoutInflater)
        setContentView(binding.root)
        
        navController = Navigation.findNavController(this, R.id.nav_host_fragment)
        
        bottomNavViewItemSelected()
        }
        
        private fun bottomNavViewItemSelected() {
        binding.bottomNavigation.setOnItemSelectedListener {menuItem ->
            when (menuItem.itemId) {
                R.id.itemID -> {
                    navController?.navigate(R.id.mainFragment)
                    return@setOnItemSelectedListener true
                }
        
                R.id.itemHistory -> {
                    navController?.navigate(R.id.historyFragment)
                    return@setOnItemSelectedListener true
                }
        
                else -> {
                    return@setOnItemSelectedListener false
                }
            }
        }
        }
        
        override fun onDestroy() {
        super.onDestroy()
        _binding = null
        }
        }
        """
    }
}

