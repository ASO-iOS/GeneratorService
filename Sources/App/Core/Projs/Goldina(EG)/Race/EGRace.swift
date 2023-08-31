//
//  File.swift
//  
//
//  Created by admin on 04.08.2023.
//

import Foundation

struct EGRace: XMLFileProviderProtocol {
    static var fileName: String = "EGRace.kt"
    
    static func fileContent(packageName: String, uiSettings: UISettings) -> String {
        return """
package \(packageName).presentation.fragments.main_fragment

import android.annotation.SuppressLint
import android.app.Dialog
import android.content.Context
import android.content.res.Resources
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.graphics.Canvas
import android.graphics.Color
import android.graphics.Paint
import android.graphics.Rect
import android.os.Bundle
import android.view.LayoutInflater
import android.view.MotionEvent
import android.view.SurfaceHolder
import android.view.SurfaceView
import android.view.View
import android.view.ViewGroup
import android.widget.FrameLayout
import androidx.appcompat.app.AlertDialog
import androidx.fragment.app.DialogFragment
import androidx.fragment.app.Fragment
import androidx.fragment.app.activityViewModels
import \(packageName).R
import \(packageName).repository.state.StateViewModel
import dagger.hilt.android.AndroidEntryPoint
import dagger.hilt.android.qualifiers.ApplicationContext
import java.util.Random
import javax.inject.Inject
import kotlin.math.roundToInt

@AndroidEntryPoint
class DialogLossFragment(
    private val score: Int = 0,
) : DialogFragment(){

    private val stateViewModel by activityViewModels<StateViewModel>()

    override fun onCreateDialog(savedInstanceState: Bundle?): Dialog {
        return activity?.let {
            return AlertDialog.Builder(it, R.style.MyDialogTheme)
                .setTitle(getString(R.string.game_over))
                .setMessage(getString(R.string.score,score))
                .setPositiveButton(getString(R.string.try_again)
                ) { _, _ ->
                    stateViewModel.setMainState()
                }.create()
        } ?: throw IllegalStateException(getString(R.string.activity_cannot_be_null))
    }

    companion object{
        const val TAG = "Loss Dialog"
    }
}

@AndroidEntryPoint
class GameFragment : Fragment() {

    private val binding by lazy { GameScreen(requireContext(),this) }

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {
        return binding.container
    }

    fun showDialog(score: Int) {
        DialogLossFragment(score).show(requireActivity().supportFragmentManager,DialogLossFragment.TAG)
    }

}

class GameScreen @Inject constructor(
    @ApplicationContext private val context: Context,
    private val gameFragment: GameFragment
) {

    private lateinit var gameView: GameView

    val container = FrameLayout(context).apply {
        layoutParams = FrameLayout.LayoutParams(
            ViewGroup.LayoutParams.MATCH_PARENT,
            ViewGroup.LayoutParams.MATCH_PARENT
        )
    }
    private fun create() = GameView(context, gameFragment).apply {
        layoutParams = FrameLayout.LayoutParams(
            ViewGroup.LayoutParams.MATCH_PARENT,
            ViewGroup.LayoutParams.MATCH_PARENT
        )
    }

    private fun setUp() {
        container.removeAllViews()
        gameView = create()
        container.addView(gameView)
    }

    init {
        setUp()
    }

}

class Background(res: Resources): GameObject() {
    val scaledBitmap: Bitmap
    init {
        x = 0f
        y = 0f
        bitmap = BitmapFactory.decodeResource(res, R.drawable.background)
        val scaleWidth = bitmap.width.toFloat() / screenWidth.toFloat()
        val newWidth = (bitmap.width / scaleWidth).roundToInt()
        val newHeight = (bitmap.height / scaleWidth).roundToInt()
        scaledBitmap = Bitmap.createScaledBitmap(bitmap, newWidth, newHeight, true)
        speed = resizeHeight(GameThread.START_SPEED_BACK)
    }
}

class Car(res: Resources): GameObject() {

    var rectTouch = Rect()

    init {
        bitmap = setImage(res, R.drawable.player, resizeWidth(150), resizeHeight(260))
        width = bitmap.width
        height = bitmap.height
        x = centerWidth()
        y = screenHeight - height * 2f
        setRect()
        setRectTouch()
    }

    fun setRectTouch() {
        val addTouchSpace = 20
        rectTouch.set(x.toInt()-addTouchSpace,
            y.toInt()-addTouchSpace,
            (x + width).toInt()+addTouchSpace,
            (y + height).toInt()+addTouchSpace)
    }
}

class Enemy(res: Resources): GameObject() {
    init {

        bitmap = setImage(res, R.drawable.enemy_car, resizeWidth(150), resizeHeight(260))
        width = bitmap.width
        height = bitmap.height
        x = randomX(width)
        y = - height * 2f
        speed = resizeHeight(40f)
        setRect()
    }
}

open class GameObject {
    var x = 0f
    var y = 0f
    var speed = 0f
    lateinit var bitmap: Bitmap
    var width = 0
    var height = 0
    var rect: Rect = Rect()
    val screenWidth: Int = Resources.getSystem().displayMetrics.widthPixels
    val screenHeight: Int = Resources.getSystem().displayMetrics.heightPixels

    private val initWidth = 1080
    private val initHeight = 2040

    fun resizeWidth(size: Int) = screenWidth * size / initWidth
    fun resizeHeight(size: Int) = screenHeight * size / initHeight
    fun resizeHeight(size: Float) = screenHeight * size / initHeight

    private fun getRandom(min: Int, max: Int): Int {
        return Random().nextInt(max - min + 1) + min
    }

    open fun collision(rect2: Rect) = rect.intersect(rect2)


    fun setImage(resources: Resources, img: Int, width: Int, height: Int): Bitmap =
        Bitmap.createScaledBitmap(
            BitmapFactory.decodeResource(resources, img),
            width,
            height,
            false
        )

    fun centerWidth(): Float = screenWidth / 2f - width / 2f

    fun randomX(width: Int) = getRandom(0, (screenWidth - width)).toFloat()

    fun setRect() {
        rect.set(x.toInt(), y.toInt(), (x + width).toInt(), (y + height).toInt())
    }



}

class GameThread(
    private val surfaceHolder: SurfaceHolder,
    private val res: Resources,
    private val gameFragment: GameFragment,

    ): Thread() {

    private var running: Boolean = true
    private var startTime: Long = 0
    private var frameTime: Long = 0
    private val fps: Int = (1000.0 / 60.0).toInt()
    private var canvas: Canvas? = null
    private var score = 0
    private var speedEnemies = START_SPEED_ENEMIES
    private var boostFlag = false
    val car: Car
    private val background:Background
    private val scoreDraw: Score
    private var enemyList: MutableList<Enemy> = mutableListOf()
    private var enemyIterator = 0
    private var enemyIteratorLimit = LIMIT_ITR

    init {
        running = true
        background = Background(res)
        scoreDraw = Score(res)
        car = Car(res)
    }

    fun setRunning(running: Boolean) {
        this.running = running
    }

    fun getRunning() = running

    override fun run() {
        while (running) {
            startTime = System.nanoTime()
            canvas = null
            try {
                canvas = surfaceHolder.lockCanvas()
                synchronized(surfaceHolder) {
                    renderBack()
                    renderCar()
                    renderEnemy()
                    renderScore()
                }
            } catch (_: Exception) {
            } finally {
                try {
                    surfaceHolder.unlockCanvasAndPost(canvas)
                } catch (_: Exception) {
                }
            }
        }
        frameTime = (System.nanoTime() - startTime) / 1000000
        if (frameTime < fps) {
            try {
                sleep(fps - frameTime)
            } catch (_: Exception) {
            }
        }
    }

    private fun renderScore() {
        canvas?.drawBitmap(scoreDraw.bitmap, scoreDraw.x, scoreDraw.y, null)
        scoreDraw.text = score.toString()
        val paint = Paint()
        paint.color = Color.WHITE
        paint.textSize =50f
        canvas?.drawText(scoreDraw.text,scoreDraw.textX,scoreDraw.textY,paint)
    }

    private fun renderBack() {
        canvas?.drawBitmap(background.scaledBitmap,
            background.x, background.y, null)
        canvas?.drawBitmap(background.scaledBitmap,
            background.x,
            (background.y - background.scaledBitmap.height),
            null)
        if (background.y >= background.scaledBitmap.height) {
            background.y = 0f
        }
        background.y += background.speed
    }


    private fun renderCar() {
        car.setRect()
        car.setRectTouch()
        canvas?.drawBitmap(car.bitmap, car.x, car.y, null)
    }

    private fun renderEnemy() {
        if (boostFlag && speedEnemies<LIMIT_SPEED && score % LIMIT_ITR_BOOST == 0){
            speedEnemies+= SPEED_BOOST
            background.speed+= SPEED_BOOST
            boostFlag= false
            enemyIteratorLimit-= DECREASE_ITR
        }
        if(enemyList.isNotEmpty() && enemyList.size> LIMIT_ENEMIES){
            enemyList.subList(0,DROP_ENEMIES).clear()

        }
        if (enemyIterator >= enemyIteratorLimit) {
            val enemy = Enemy(res)
            enemy.speed = enemy.resizeHeight(speedEnemies)
            enemyList.add(enemy)
            enemyIterator = 0
            score++
            boostFlag = true
        } else {
            enemyIterator++
        }

        for (enemy in enemyList) {
            enemy.setRect()
            enemy.y += enemy.speed
            if (enemy.collision(car.rect)) {
                running = false
                gameFragment.showDialog(score)
            }
            canvas?.drawBitmap(enemy.bitmap, enemy.x, enemy.y, null)
        }
    }

    companion object{
        const val LIMIT_ITR_BOOST = 40
        const val START_SPEED_ENEMIES = 32f
        const val START_SPEED_BACK = 20f
        const val SPEED_BOOST = 7f
        const val DECREASE_ITR = 2
        const val LIMIT_ITR = 32
        const val LIMIT_ENEMIES = 100
        const val DROP_ENEMIES = 50
        const val LIMIT_SPEED = 74
    }
}

@SuppressLint("ViewConstructor")
class GameView(
    context: Context,
    private val gameFragment: GameFragment
) : SurfaceView(context), SurfaceHolder.Callback {

    private var gameThread: GameThread
    private var touchX =0f
    private var touchY = 0f

    init {
        holder.addCallback(this)
        gameThread = GameThread(holder, resources,gameFragment)
        isFocusable = true
    }

    override fun surfaceCreated(holder: SurfaceHolder) {
        if (!gameThread.getRunning()) {
            gameThread = GameThread(holder, resources,gameFragment)
        } else {
            gameThread.start()
        }
    }

    override fun surfaceChanged(holder: SurfaceHolder, format: Int, width: Int, height: Int) {}

    override fun surfaceDestroyed(holder: SurfaceHolder) {
        var retry = true
        while (retry) {
            try {
                gameThread.setRunning(false)
                gameThread.join()
            } catch (_: InterruptedException) {}
            retry = false
        }
    }

    @SuppressLint("ClickableViewAccessibility")
    override fun onTouchEvent(event: MotionEvent): Boolean {
        if (gameThread.car.rectTouch.contains( event.x.toInt(), event.y.toInt())) {
            when (event.action) {
                MotionEvent.ACTION_DOWN -> {
                    touchX = event.x
                    touchY = event.y
                }

                MotionEvent.ACTION_MOVE -> {
                    val movedX = event.x
                    val movedY = event.y

                    val dx = movedX - touchX
                    val dy = movedY -  touchY
                    gameThread.car.x += dx
                    gameThread.car.y += dy
                    gameThread.car.setRect()
                    gameThread.car.setRectTouch()
                    touchX = movedX
                    touchY = movedY
                }
                else ->return true
            }
        }
        return true
    }
    fun res(): Resources = resources

}

class Score(res:Resources): GameObject() {
    val textX:Float
    val textY:Float
    var text:String = ""

    init{
        x = 10f
        y =100f
        textX= x+80f
        textY = y+50f
        bitmap = setImage(res, R.drawable.fire, resizeWidth(50), resizeHeight(50))
        width = bitmap.width
        height = bitmap.height
    }
}
"""
    }
    
    static func dependencies(_ mainData: MainData) -> ANDData {
        return ANDData(mainFragmentData: ANDMainFragment(imports: "", content: ""), mainActivityData: ANDMainActivity(imports: """
import android.view.View
import android.os.Build
import \(mainData.packageName).presentation.fragments.main_fragment.GameFragment
""", extraFunc: """
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
            window.setDecorFitsSystemWindows(false)
        } else {
            @Suppress("DEPRECATION")
            window.decorView.systemUiVisibility = View.SYSTEM_UI_FLAG_FULLSCREEN
        }
""", content: "", extraStates: """
                    is FragmentState.GameState -> replace(GameFragment())
"""), themesData: ANDThemesData(isDefault: true, content: """
    <style name="MyDialogTheme" parent="Theme.AppCompat.Light.Dialog.Alert">
        <item name="android:background">@color/buttonColorPrimary</item>
        <item name="buttonBarPositiveButtonStyle">@style/Widget.ButtonTryAgain.PositiveButton</item>
        <item name="android:textColor">@color/textColorPrimary</item>
        <item name="android:textColorPrimary">@color/textColorPrimary</item>
    </style>

    <style name="Widget.ButtonTryAgain.PositiveButton" parent="Widget.MaterialComponents.Button.TextButton.Dialog">
        <item name="materialThemeOverlay">@style/ThemeOverlay.EGRace.PositiveButton</item>
    </style>

    <style name="ThemeOverlay.EGRace.PositiveButton" parent="">
        <item name="colorPrimary">@color/buttonTextColorPrimary</item>
    </style>
"""), stringsData: ANDStringsData(additional: """
            <string name="new_game">start</string>
            <string name="game_over">Game Over</string>
            <string name="try_again">Try Again</string>
            <string name="score">Your score is %1$d</string>
            <string name="activity_cannot_be_null">Activity cannot be null</string>
        """), colorsData: ANDColorsData(additional: """
        <color name="backColorPrimary">#\(mainData.uiSettings.backColorPrimary ?? "FFFFFF")</color>
        <color name="buttonTextColorPrimary">#\(mainData.uiSettings.buttonTextColorPrimary ?? "FFFFFF")</color>
        <color name="textColorPrimary">#\(mainData.uiSettings.textColorPrimary ?? "FFFFFF")</color>
        <color name="buttonColorPrimary">#\(mainData.uiSettings.buttonColorPrimary ?? "FFFFFF")</color>
        """), stateViewModelData: """
            fun setGameState() {
                _state.value = FragmentState.GameState
            }
        """, fragmentStateData: """
            object GameState : FragmentState()
        """
        )
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
import dependencies.Java
import dependencies.Dependencies

apply plugin: 'com.android.application'
apply plugin: 'org.jetbrains.kotlin.android'
apply plugin: 'kotlin-kapt'
apply plugin: 'dagger.hilt.android.plugin'

android {
    compileSdk Versions.compilesdk
    namespace Application.id

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
            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
            signingConfig signingConfigs.debug
        }
    }
    compileOptions {
        sourceCompatibility Java.java_version
        targetCompatibility Java.java_version
    }
    kotlinOptions {
        jvmTarget = '1.8'
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
    implementation Dependencies.hilt_viewmodel
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

object Java {
    const val java_version = "1.8"
}

object Versions {
    const val gradle = "7.4.2"
    const val compilesdk = 33
    const val minsdk = 24
    const val targetsdk = 33
    const val kotlin = "1.6.10"
    const val kotlin_coroutines = "1.6.0"
    const val hilt = "2.40.3"
    const val hilt_viewmodel = "1.0.0-alpha03"
    const val hilt_viewmodel_compiler = "1.0.0"

    const val ktx = "1.7.0"
    const val lifecycle = "2.4.1"
    const val fragment_ktx = "1.4.1"
    const val appcompat = "1.4.1"
    const val material = "1.5.0"

    const val compose = "1.1.1"
    const val compose_navigation = "2.5.0-beta01"
    const val activity_compose = "1.4.0"
    const val compose_hilt_nav = "1.0.0"

    const val oneSignal = "4.6.7"
    const val glide = "4.12.0"
    const val swipe = "0.19.0"
    const val glide_skydoves = "1.3.9"
    const val retrofit = "2.9.0"
    const val okhttp = "4.9.1"
    const val room = "2.4.2"
    const val coil = "1.3.2"
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
    const val compose_runtime_livedata = "androidx.compose.runtime:runtime-livedata:${Versions.compose}"
    const val compose_mat_icons_core = "androidx.compose.material:material-icons-core:${Versions.compose}"
    const val compose_mat_icons_core_extended = "androidx.compose.material:material-icons-extended:${Versions.compose}"

    const val coroutines = "org.jetbrains.kotlinx:kotlinx-coroutines-android:${Versions.kotlin_coroutines}"
    const val fragment_ktx = "androidx.fragment:fragment-ktx:${Versions.fragment_ktx}"

    const val lifecycle_viewmodel = "androidx.lifecycle:lifecycle-viewmodel-ktx:${Versions.lifecycle}"
    const val lifecycle_runtime = "androidx.lifecycle:lifecycle-runtime-ktx:${Versions.lifecycle}"

    const val retrofit = "com.squareup.retrofit2:retrofit:${Versions.retrofit}"
    const val converter_gson = "com.squareup.retrofit2:converter-gson:${Versions.retrofit}"
    const val okhttp = "com.squareup.okhttp3:okhttp:${Versions.okhttp}"
    const val okhttp_login_interceptor = "com.squareup.okhttp3:logging-interceptor:${Versions.okhttp}"

    const val room_runtime = "androidx.room:room-runtime:${Versions.room}"
    const val room_compiler = "androidx.room:room-compiler:${Versions.room}"
    const val room_ktx = "androidx.room:room-ktx:${Versions.room}"

    const val onesignal = "com.onesignal:OneSignal:${Versions.oneSignal}"
    
    const val swipe_to_refresh = "com.google.accompanist:accompanist-swiperefresh:${Versions.swipe}"

    const val glide = "com.github.bumptech.glide:glide:${Versions.glide}"
    const val glide_skydoves = "com.github.skydoves:landscapist-glide:${Versions.glide_skydoves}"
    const val glide_compiler = "com.github.bumptech.glide:compiler:${Versions.glide}"

    const val dagger_hilt = "com.google.dagger:hilt-android:${Versions.hilt}"
    const val dagger_hilt_compiler = "com.google.dagger:hilt-android-compiler:${Versions.hilt}"
    const val hilt_viewmodel = "androidx.hilt:hilt-lifecycle-viewmodel:${Versions.hilt_viewmodel}"
    const val hilt_viewmodel_compiler = "androidx.hilt:hilt-compiler:${Versions.hilt_viewmodel_compiler}"
    const val coil_compose = "io.coil-kt:coil-compose:${Versions.coil}"
    const val coil_svg = "io.coil-kt:coil-svg:${Versions.coil}"
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

import android.annotation.SuppressLint
import android.content.pm.ActivityInfo
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.view.animation.AnimationUtils
import androidx.fragment.app.Fragment
import androidx.fragment.app.activityViewModels
import \(packageName).R
import \(packageName).databinding.FragmentMainBinding
import \(packageName).repository.state.StateViewModel
import dagger.hilt.android.AndroidEntryPoint

@AndroidEntryPoint
class MainFragment : Fragment() {

    private val stateViewModel by activityViewModels<StateViewModel>()
    private lateinit var binding: FragmentMainBinding

    @SuppressLint("SourceLockedOrientationActivity")
    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {
        activity?.requestedOrientation = ActivityInfo.SCREEN_ORIENTATION_PORTRAIT
        binding = FragmentMainBinding.inflate(layoutInflater)
        binding.tvAppName.animation = AnimationUtils.loadAnimation(context, R.anim.from_top)
        binding.ivIcon.animation = AnimationUtils.loadAnimation(context, R.anim.from_top)
        binding.btnStart.animation = AnimationUtils.loadAnimation(context, R.anim.from_bottom)
        return binding.root
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        binding.btnStart.setOnClickListener {
            stateViewModel.setGameState()
        }
    }
}

""", fileName: "MainFragment.kt")
    }
    
    static func layout(_ uiSettings: UISettings) -> [XMLLayoutData] {
        let fragmentMain = """
<?xml version="1.0" encoding="utf-8"?>
<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:tools="http://schemas.android.com/tools"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:orientation="vertical"
    android:gravity="center"
    android:background="@color/backColorPrimary"
    tools:context=".presentation.fragments.main_fragment.MainFragment">

    <ImageView
        android:id="@+id/ivIcon"
        android:layout_width="@dimen/icon_dimens"
        android:layout_height="@dimen/icon_dimens"
        android:src="@drawable/player"
        android:contentDescription="@string/app_name" />
    <TextView
        android:id="@+id/tvAppName"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:gravity="center"
        android:text="@string/app_name"
        android:textColor="@color/textColorPrimary"
        android:textSize="@dimen/textSizePrimary"/>


    <Button
        android:id="@+id/btnStart"
        android:layout_width="@dimen/btn_width"
        android:layout_height="wrap_content"
        android:paddingHorizontal="@dimen/padding_hor"
        android:text="@string/new_game"
        android:textSize="@dimen/btn_text"
        android:backgroundTint="@color/buttonColorPrimary"
        android:textColor="@color/buttonTextColorPrimary"
        android:layout_marginTop="80dp"/>


</LinearLayout>
"""
        let fragmentMainName = "fragment_main.xml"
        return [XMLLayoutData(content: fragmentMain, name: fragmentMainName)]
    }
    
    static func dimens(_ uiSettings: UISettings) -> XMLLayoutData {
        return XMLLayoutData(content: """
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <dimen name="icon_dimens">100dp</dimen>
    <dimen name="textSizePrimary">50sp</dimen>
    <dimen name="padding_hor">20dp</dimen>
    <dimen name="btn_width">200dp</dimen>
    <dimen name="btn_text">20sp</dimen>
</resources>
""", name: "dimens.xml")
    }
    
    static func anim() -> [XMLLayoutData] {
        let bottom = """
<?xml version="1.0" encoding="utf-8"?>
<set xmlns:android="http://schemas.android.com/apk/res/android"
    android:shareInterpolator="false" >
    <translate
        android:duration="1000"
        android:fromXDelta="0"
        android:fromYDelta="300%" />
    <alpha
        android:fromAlpha="0"
        android:toAlpha="1"
        android:duration="1000"/>
</set>
"""
        let bottomName = "from_bottom.xml"
        let top = """
<?xml version="1.0" encoding="utf-8"?>
<set xmlns:android="http://schemas.android.com/apk/res/android"
    android:shareInterpolator="false" >
    <translate
        android:duration="1000"
        android:fromXDelta="0"
        android:fromYDelta="-300%" />
    <alpha
        android:fromAlpha="0"
        android:toAlpha="1"
        android:duration="1000"/>
</set>
"""
        let topName = "from_top.xml"
        return [XMLLayoutData(content: bottom, name: bottomName), XMLLayoutData(content: top, name: topName)]
    }
    
    
}
