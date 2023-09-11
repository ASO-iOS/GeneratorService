//
//  File.swift
//  
//
//  Created by admin on 04.08.2023.
//

import Foundation

struct EGLuckyNumber: XMLFileProviderProtocol {
    static var fileName = "\(NamesManager.shared.fileName).kt"
    
    
    
    static func fileContent(packageName: String, uiSettings: UISettings) -> String {
        return """
package \(packageName).presentation.fragments.main_fragment

import androidx.lifecycle.ViewModel
import dagger.hilt.android.lifecycle.HiltViewModel
import javax.inject.Inject

@HiltViewModel
class NumberViewModel @Inject constructor(): ViewModel() {

    fun getResult(inputNumber: String, hiddenNumber: Int, resultCallback: (result: Boolean) -> Unit){
        val number = parseNumber(inputNumber)
        if(number>=0){
            if(number == hiddenNumber){
                resultCallback.invoke(true)
            }else{
                resultCallback.invoke(false)
            }

        }
    }

    private fun parseNumber(number: String?): Int {
        return number?.trim()?.toInt() ?: -1
    }
}
"""
    }
    
    static func dependencies(_ mainData: MainData) -> ANDData {
        return ANDData(mainFragmentData: ANDMainFragment(imports: "", content: ""), mainActivityData: ANDMainActivity(imports: "", extraFunc: "", content: ""), themesData: ANDThemesData(isDefault: true, content: ""), stringsData: ANDStringsData(additional: """
    <string name="main_info">Try to guess the lucky number from 0 to 10…</string>
    <string name="congratulation">Right!\\nCongratulate, you\\'re really lucky</string>
    <string name="wrong_message">Didn\\'t guess, try again!</string>
    <string name="think_up">think up</string>
    <string name="give_up">Give Up</string>
    <string name="_try">Try</string>
    <string name="icon_result">icon result</string>
    <string name="hint"> </string>
"""), colorsData: ANDColorsData(additional: """
    <color name="backColorPrimary">#\(mainData.uiSettings.backColorPrimary ?? "FFFFFF")</color>
    <color name="backColorSecondary">#\(mainData.uiSettings.backColorSecondary ?? "FFFFFF")</color>
    <color name="buttonTextColorPrimary">#\(mainData.uiSettings.buttonTextColorPrimary ?? "FFFFFF")</color>
    <color name="surfaceColor">#\(mainData.uiSettings.surfaceColor ?? "FFFFFF")</color>
    <color name="textColorPrimary">#\(mainData.uiSettings.textColorPrimary ?? "FFFFFF")</color>
    <color name="buttonColorPrimary">#\(mainData.uiSettings.buttonColorPrimary ?? "FFFFFF")</color>
    <color name="errorColor">#\(mainData.uiSettings.errorColor ?? "FFFFFF")</color>
"""))
    }
    
    static func gradle(_ packageName: String) -> GradleFilesData {
        let projectGradle = """
import dependencies.Versions
import dependencies.Build

buildscript {
    ext {
        compose_version = Versions.compose
        kotlin_version = Versions.kotlin
    }

    repositories {
        gradlePluginPortal()
        google()
        mavenCentral()
    }
    dependencies {
        classpath Build.build_tools
        classpath Build.kotlin_gradle_plugin
        classpath Build.hilt_plugin
    }
}

task clean(type: Delete) {
    delete rootProject.buildDir
}
"""
        let projectGradleName = "build.gradle"
        let moduleGradle = """
import dependencies.Versions
import dependencies.Application
import dependencies.Dependencies

apply plugin: 'com.android.application'
apply plugin: 'org.jetbrains.kotlin.android'
apply plugin: 'kotlin-kapt'
apply plugin: 'dagger.hilt.android.plugin'

android {
    namespace Application.id
    compileSdk Versions.compilesdk

    defaultConfig {
        applicationId Application.id
        minSdk Versions.minsdk
        targetSdk Versions.targetsdk
        versionCode Application.version_code
        versionName Application.version_name

        testInstrumentationRunner "androidx.test.runner.AndroidJUnitRunner"
        vectorDrawables {
            useSupportLibrary true
        }
    }

    buildTypes {
        release {
            minifyEnabled true
            shrinkResources true
            signingConfig signingConfigs.debug
            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
        }
    }
    compileOptions {
        sourceCompatibility JavaVersion.VERSION_17
        targetCompatibility JavaVersion.VERSION_17
    }
    kotlinOptions {
        jvmTarget = '17'
    }
    buildFeatures {
        compose true
        viewBinding true
    }
    composeOptions {
        kotlinCompilerExtensionVersion compose_version
    }
    bundle {
        storeArchive {
            enable = false
        }
    }
}

dependencies {

    implementation Dependencies.core_ktx
    implementation Dependencies.appcompat
    implementation Dependencies.material
    implementation Dependencies.compose_ui
    implementation Dependencies.compose_material
    implementation Dependencies.compose_preview
    implementation Dependencies.compose_material3
    implementation Dependencies.compose_activity
    implementation Dependencies.compose_ui_tooling
    implementation Dependencies.compose_navigation
    implementation Dependencies.compose_hilt_nav
    implementation Dependencies.compose_foundation
    implementation Dependencies.compose_runtime
    implementation Dependencies.compose_runtime_livedata
    implementation Dependencies.compose_mat_icons_core
    implementation Dependencies.compose_mat_icons_core_extended
    implementation Dependencies.coroutines
    implementation Dependencies.fragment_ktx
    implementation Dependencies.lifecycle_viewmodel
    implementation Dependencies.lifecycle_runtime
    implementation Dependencies.dagger_hilt
    kapt Dependencies.dagger_hilt_compiler
    kapt Dependencies.hilt_viewmodel_compiler
    
}
"""
        let moduleGradleName = "build.gradle"

        let dependencies = """
package dependencies

object Application {
    const val id = "\(packageName)"
    const val version_code = 1
    const val version_name = "1.0"
}

object Build {
    const val build_tools = "com.android.tools.build:gradle:${Versions.gradle}"
    const val kotlin_gradle_plugin = "org.jetbrains.kotlin:kotlin-gradle-plugin:${Versions.kotlin}"
    const val hilt_plugin = "com.google.dagger:hilt-android-gradle-plugin:${Versions.hilt}"
}

object Versions {
    const val gradle = "8.0.0"
    const val compilesdk = 33
    const val minsdk = 24
    const val targetsdk = 33
    const val kotlin = "1.8.10"
    const val kotlin_coroutines = "1.6.3"
    const val hilt = "2.43.2"
    const val hilt_viewmodel_compiler = "1.0.0"

    const val ktx = "1.10.0"
    const val lifecycle = "2.6.1"
    const val fragment_ktx = "1.5.7"
    const val appcompat = "1.6.1"
    const val material = "1.9.0"
    const val accompanist = "0.31.1-alpha"

    const val compose = "1.4.3"
    const val compose_navigation = "2.5.0-beta01"
    const val activity_compose = "1.7.1"
    const val compose_hilt_nav = "1.0.0"

    const val oneSignal = "4.6.7"
    const val glide = "4.12.0"
    const val swipe = "0.19.0"
    const val glide_skydoves = "1.3.9"
    const val retrofit = "2.9.0"
    const val okhttp = "4.10.0"
    const val room = "2.5.0"
    const val coil = "1.3.2"
    const val exp = "0.4.8"
    const val calend = "0.5.1"
    const val paging_version = "3.1.1"
}

object Dependencies {
    const val core_ktx = "androidx.core:core-ktx:${Versions.ktx}"
    const val appcompat = "androidx.appcompat:appcompat:${Versions.appcompat}"
    const val material = "com.google.android.material:material:${Versions.material}"

    const val compose_ui = "androidx.compose.ui:ui:${Versions.compose}"
    const val compose_material = "androidx.compose.material:material:${Versions.compose}"
    const val compose_preview = "androidx.compose.ui:ui-tooling-preview:${Versions.compose}"
    const val compose_activity = "androidx.activity:activity-compose:${Versions.activity_compose}"
    const val compose_ui_tooling = "androidx.compose.ui:ui-tooling:${Versions.compose}"
    const val compose_navigation = "androidx.navigation:navigation-compose:${Versions.compose_navigation}"
    const val compose_hilt_nav = "androidx.hilt:hilt-navigation-compose:${Versions.compose_hilt_nav}"
    const val compose_foundation = "androidx.compose.foundation:foundation:${Versions.compose}"
    const val compose_runtime = "androidx.compose.runtime:runtime:${Versions.compose}"
    const val compose_material3 = "androidx.compose.material3:material3:1.1.0-rc01"
    const val compose_runtime_livedata = "androidx.compose.runtime:runtime-livedata:${Versions.compose}"
    const val compose_mat_icons_core = "androidx.compose.material:material-icons-core:${Versions.compose}"
    const val compose_mat_icons_core_extended = "androidx.compose.material:material-icons-extended:${Versions.compose}"

    const val coroutines = "org.jetbrains.kotlinx:kotlinx-coroutines-android:${Versions.kotlin_coroutines}"
    const val fragment_ktx = "androidx.fragment:fragment-ktx:${Versions.fragment_ktx}"
    const val compose_system_ui_controller = "com.google.accompanist:accompanist-systemuicontroller:${Versions.accompanist}"
    const val compose_permissions = "com.google.accompanist:accompanist-permissions:${Versions.accompanist}"

    const val lifecycle_viewmodel = "androidx.lifecycle:lifecycle-viewmodel-ktx:${Versions.lifecycle}"
    const val lifecycle_runtime = "androidx.lifecycle:lifecycle-runtime-ktx:${Versions.lifecycle}"

    const val retrofit = "com.squareup.retrofit2:retrofit:${Versions.retrofit}"
    const val converter_gson = "com.squareup.retrofit2:converter-gson:${Versions.retrofit}"
    const val okhttp = "com.squareup.okhttp3:okhttp:${Versions.okhttp}"
    const val okhttp_login_interceptor = "com.squareup.okhttp3:logging-interceptor:${Versions.okhttp}"

    const val room_runtime = "androidx.room:room-runtime:${Versions.room}"
    const val room_compiler = "androidx.room:room-compiler:${Versions.room}"
    const val room_ktx = "androidx.room:room-ktx:${Versions.room}"
    const val roomPaging = "androidx.room:room-paging:${Versions.room}"

    const val onesignal = "com.onesignal:OneSignal:${Versions.oneSignal}"
    
    const val swipe_to_refresh = "com.google.accompanist:accompanist-swiperefresh:${Versions.swipe}"

    const val glide = "com.github.bumptech.glide:glide:${Versions.glide}"
    const val glide_skydoves = "com.github.skydoves:landscapist-glide:${Versions.glide_skydoves}"
    const val glide_compiler = "com.github.bumptech.glide:compiler:${Versions.glide}"

    const val dagger_hilt = "com.google.dagger:hilt-android:${Versions.hilt}"
    const val dagger_hilt_compiler = "com.google.dagger:hilt-android-compiler:${Versions.hilt}"
    const val hilt_viewmodel_compiler = "androidx.hilt:hilt-compiler:${Versions.hilt_viewmodel_compiler}"
    const val coil_compose = "io.coil-kt:coil-compose:${Versions.coil}"
    const val coil_svg = "io.coil-kt:coil-svg:${Versions.coil}"
    const val expression = "net.objecthunter:exp4j:${Versions.exp}"
    const val calendar = "io.github.boguszpawlowski.composecalendar:composecalendar:${Versions.calend}"
    const val calendar_date = "io.github.boguszpawlowski.composecalendar:kotlinx-datetime:${Versions.calend}"
    const val paging = "androidx.paging:paging-runtime:${Versions.paging_version}"
    const val pagingCommon = "androidx.paging:paging-common:${Versions.paging_version}"
    const val pagingCompose = "androidx.paging:paging-compose:1.0.0-alpha18"
}
"""
        let dependenciesName = "Dependencies.kt"

        return GradleFilesData(
            projectBuildGradle: GradleFileInfoData(
                content: projectGradle,
                name: projectGradleName
            ),
            moduleBuildGradle: GradleFileInfoData(
                content: moduleGradle,
                name: moduleGradleName
            ),
            dependencies: GradleFileInfoData(
                content: dependencies,
                name: dependenciesName
            ))
    }
    
    static func cmfHandler(_ packageName: String) -> ANDMainFragmentCMF {
        return ANDMainFragmentCMF(content: """
package \(packageName).presentation.fragments.main_fragment

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.core.content.ContextCompat
import androidx.fragment.app.Fragment
import androidx.fragment.app.viewModels
import \(packageName).R
import \(packageName).databinding.FragmentMainBinding
import dagger.hilt.android.AndroidEntryPoint
import java.util.Random


@AndroidEntryPoint
class MainFragment : Fragment() {

    private lateinit var binding:FragmentMainBinding
    private var maxRange = 10
    private var hiddenNumber:Int = 0
    private val viewModel: NumberViewModel by viewModels()
    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {
        binding = FragmentMainBinding.inflate(layoutInflater)

        return binding.root
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        with(binding) {
            btnStart.setOnClickListener {
                tvSuccess.visibility = View.GONE
                tvInfo.visibility = View.VISIBLE
                etNumber.visibility = View.VISIBLE
                btnStart.visibility = View.GONE
                layoutBtnGame.visibility = View.VISIBLE
                ivResult.setImageDrawable(
                    ContextCompat.getDrawable(
                        requireContext(),
                        R.drawable.ic_question
                    )
                )
                hiddenNumber = makeNumber(maxRange)

            }
            btnTry.setOnClickListener {
                if (etNumber.text.isNotEmpty())
                    checkNumber()
            }
            btnGiveUp.setOnClickListener {
                setDefault()
            }
        }
    }

    private fun setDefault() {
        with(binding) {
            ivResult.setImageDrawable(
                ContextCompat.getDrawable(
                    requireContext(),
                    R.drawable.clover
                )
            )
            layoutBtnGame.visibility = View.GONE
            btnStart.visibility = View.VISIBLE
            tvError.visibility = View.INVISIBLE
            etNumber.text.clear()
        }
    }

    private fun checkNumber() {
        with(binding) {
            viewModel.getResult(etNumber.text.toString(),hiddenNumber){result ->
                if(result){
                    tvSuccess.visibility = View.VISIBLE
                    tvInfo.visibility = View.GONE
                    etNumber.visibility = View.GONE
                    setDefault()
                }else{
                    tvError.visibility = View.VISIBLE
                    etNumber.text.clear()
                }
            }
        }
    }

    private fun makeNumber(max:Int):Int {
        return Random().nextInt(max + 1)
    }
}

""", fileName: "MainFragment.kt")
    }
    
    static func layout(_ uiSettings: UISettings) -> [XMLLayoutData] {
        let mainFragment = """
<?xml version="1.0" encoding="utf-8"?>
<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:app="http://schemas.android.com/apk/res-auto"
    xmlns:tools="http://schemas.android.com/tools"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:background="@color/backColorPrimary"
    android:orientation="vertical"
    android:gravity="center_horizontal">

    <ImageView
        android:id="@+id/ivResult"
        android:layout_width="@dimen/image_size_150dp"
        android:layout_height="@dimen/image_size_150dp"
        android:layout_marginTop="@dimen/margin_35dp"
        android:background="@drawable/border_icon"
        android:padding="@dimen/_40dp"
        android:src="@drawable/clover"
        android:contentDescription="@string/icon_result" />

    <androidx.cardview.widget.CardView
        android:id="@+id/cvMain"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:layout_marginTop="@dimen/_40dp"
        app:cardBackgroundColor="@color/surfaceColor"
        app:cardCornerRadius="@dimen/corner_radius_20dp"
        app:cardElevation="@dimen/default_elevation">

        <LinearLayout
            android:layout_width="wrap_content"
            android:layout_height="wrap_content"
            android:gravity="center"
            android:orientation="vertical"
            android:padding="@dimen/_20dp">

            <TextView
                android:id="@+id/tvInfo"
                android:layout_width="wrap_content"
                android:layout_height="wrap_content"
                android:layout_marginTop="@dimen/_20dp"
                android:layout_marginBottom="@dimen/margin_10dp"
                android:maxWidth="@dimen/max_width"
                android:maxLines="2"
                android:text="@string/main_info"
                android:textColor="@color/textColorPrimary"
                android:textSize="@dimen/text_20sp"
                android:textStyle="bold" />

            <TextView
                android:id="@+id/tvSuccess"
                android:layout_width="wrap_content"
                android:layout_height="wrap_content"
                android:layout_marginTop="@dimen/margin_10dp"
                android:lines="2"
                android:text="@string/congratulation"
                android:textAlignment="center"
                android:textColor="@color/textColorPrimary"
                android:textSize="@dimen/text_20sp"
                android:textStyle="bold"
                android:visibility="gone" />


            <EditText
                android:id="@+id/etNumber"
                android:layout_width="50dp"
                android:layout_height="@dimen/_48dp"
                android:layout_marginHorizontal="@dimen/margin_50dp"
                android:layout_marginBottom="@dimen/margin_5dp"
                android:autofillHints=""
                android:backgroundTint="@color/textColorPrimary"
                android:hint="@string/hint"
                android:inputType="number"
                android:textColor="@color/textColorPrimary"
                tools:ignore="LabelFor" />

            <TextView
                android:id="@+id/tvError"
                android:layout_width="wrap_content"
                android:layout_height="wrap_content"
                android:layout_marginBottom="@dimen/margin_50dp"
                android:text="@string/wrong_message"
                android:textColor="@color/errorColor"
                android:visibility="invisible" />

            <Button
                android:id="@+id/btnStart"
                android:layout_width="wrap_content"
                android:layout_height="wrap_content"
                android:backgroundTint="@color/buttonColorPrimary"
                android:text="@string/think_up"
                android:textColor="@color/buttonTextColorPrimary" />

            <LinearLayout
                android:id="@+id/layoutBtnGame"
                android:layout_width="match_parent"
                android:layout_height="wrap_content"
                android:gravity="center"
                android:orientation="horizontal"
                android:visibility="gone">

                <Button
                    android:id="@+id/btnGiveUp"
                    android:layout_width="wrap_content"
                    android:layout_height="wrap_content"
                    android:layout_marginEnd="@dimen/margin_35dp"
                    android:backgroundTint="@color/buttonColorPrimary"
                    android:text="@string/give_up"
                    android:textColor="@color/buttonTextColorPrimary"
                    style="?android:attr/buttonBarButtonStyle" />

                <Button
                    android:id="@+id/btnTry"
                    android:layout_width="wrap_content"
                    android:layout_height="wrap_content"
                    android:backgroundTint="@color/buttonColorPrimary"
                    android:text="@string/_try"
                    android:textColor="@color/buttonTextColorPrimary"
                    style="?android:attr/buttonBarButtonStyle" />

            </LinearLayout>
        </LinearLayout>
    </androidx.cardview.widget.CardView>

</LinearLayout>
"""
        let mainFragmentName = "fragment_main.xml"
        return [XMLLayoutData(content: mainFragment, name: mainFragmentName)]
    }
    
    static func dimens(_ uiSettings: UISettings) -> XMLLayoutData {
        return XMLLayoutData(content: """
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <dimen name="image_size_150dp">150dp</dimen>
    <dimen name="margin_35dp">35dp</dimen>
    <dimen name="_40dp">40dp</dimen>
    <dimen name="corner_radius_20dp">20dp</dimen>
    <dimen name="default_elevation">0dp</dimen>
    <dimen name="_20dp">20dp</dimen>
    <dimen name="margin_10dp">10dp</dimen>
    <dimen name="max_width">300dp</dimen>
    <dimen name="text_20sp">20sp</dimen>
    <dimen name="margin_50dp">50dp</dimen>
    <dimen name="margin_5dp">5dp</dimen>
    <dimen name="_48dp">48dp</dimen>
</resources>
""", name: "dimens.xml")
    }
    
    
}
