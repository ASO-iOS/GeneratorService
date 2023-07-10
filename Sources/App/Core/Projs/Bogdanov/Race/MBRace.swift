//
//  File.swift
//  
//
//  Created by admin on 26.06.2023.
//

import Foundation

struct MBRace: FileProviderProtocol {
    static var fileName = "MBRace.kt"
    
    static func fileContent(
        packageName: String,
        uiSettings: UISettings
    ) -> String {
        return """
package \(packageName).presentation.fragments.main_fragment

import android.content.Context
import android.content.res.Resources
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.graphics.Rect
import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import android.os.Build
import androidx.annotation.DrawableRes
import androidx.compose.foundation.Canvas
import androidx.compose.foundation.background
import androidx.compose.foundation.isSystemInDarkTheme
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Pause
import androidx.compose.material.icons.filled.PlayArrow
import androidx.compose.material.icons.filled.Refresh
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.material3.Typography
import androidx.compose.material3.darkColorScheme
import androidx.compose.material3.dynamicDarkColorScheme
import androidx.compose.material3.dynamicLightColorScheme
import androidx.compose.material3.lightColorScheme
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.collectAsState
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.scale
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.ImageBitmap
import androidx.compose.ui.graphics.asImageBitmap
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import androidx.lifecycle.viewmodel.compose.viewModel
import dagger.Module
import dagger.Provides
import dagger.hilt.InstallIn
import dagger.hilt.android.lifecycle.HiltViewModel
import dagger.hilt.android.qualifiers.ApplicationContext
import dagger.hilt.components.SingletonComponent
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.CoroutineStart
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.Job
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.delay
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch
import javax.inject.Inject
import javax.inject.Singleton
import kotlin.random.Random
import \(packageName).R

val backColorPrimary = Color(0xFF\(uiSettings.backColorPrimary ?? "FFFFFF"))
val backColorSecondary = Color(0xFF\(uiSettings.backColorSecondary ?? "FFFFFF"))
val textColorPrimary = Color(0xFF\(uiSettings.textColorPrimary ?? "FFFFFF"))
val buttonColor = Color(0xFF\(uiSettings.buttonColorPrimary ?? "FFFFFF"))
val buttonTextColor = Color(0xFF\(uiSettings.buttonTextColorPrimary ?? "FFFFFF"))

val enterText = "\(enterText())"


@Composable
fun MBRace(appViewModel: AppViewModel = viewModel()) {
    val context = LocalContext.current
    LaunchedEffect(key1 = Unit) {
        BitmapsInitializer(context.resources)
    }
    val screenState = appViewModel.screenState.collectAsState()

    when (screenState.value) {
        ScreenState.Running -> GameCanvas()
        ScreenState.Paused -> PauseScreen()
        ScreenState.Finished -> FinishScreen()
        ScreenState.FirstEnter -> FirstEnterScreen()
        else -> {}
    }
}

@Composable
fun FinishScreen(appViewModel: AppViewModel = viewModel()) {
    val gameState = appViewModel.gameState.collectAsState()
    Column(
        modifier = Modifier
            .fillMaxSize()
            .background(backColorPrimary),
        verticalArrangement = Arrangement.Center,
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        Text(
            text = "Game Over",
            style = MaterialTheme.typography.displayLarge,
            color = textColorPrimary,
            fontSize = 50.sp
        )
        Text(
            text = "Score: ${gameState.value.score}",
            style = MaterialTheme.typography.displayLarge,
            color = textColorPrimary,
            fontSize = 38.sp
        )
        Spacer(
            modifier = Modifier
                .padding(vertical = 16.dp)
                .background(backColorSecondary)
        )
        IconButton(
            onClick = {
                appViewModel.restartGame()
            }, modifier = Modifier.size(100.dp)
        ) {
            Icon(
                imageVector = Icons.Default.Refresh,
                contentDescription = "Restart",
                modifier = Modifier.size(100.dp)
                    .background(backColorSecondary),
                tint = buttonTextColor
            )
        }
    }
}

@Composable
fun GameCanvas(appViewModel: AppViewModel = viewModel()) {
    val gameState = appViewModel.gameState.collectAsState()
    Box(
        modifier = Modifier
            .fillMaxSize()
            .background(backColorSecondary),
        contentAlignment = Alignment.Center
    ) {
        Canvas(
            modifier = Modifier
                .fillMaxSize()
                .background(backColorSecondary)
        ) {

            gameState.value.background.backgrounds.forEach { background ->
                background.bitmap?.let { bitmap ->
                    drawImage(bitmap, Offset(0f, background.y + background.offset))
                }
            }
            gameState.value.player.also { player ->
                player.bitmap?.let { bitmap ->
                    drawImage(bitmap, Offset(player.x, player.y))
                }
            }
            gameState.value.enemies.forEach { enemy ->
                enemy.bitmap?.let { bitmap ->
                    drawImage(bitmap, Offset(enemy.x, enemy.y))
                }
            }
        }
        IconButton(
            modifier = Modifier
                .scale(2f)
                .padding(24.dp)
                .background(buttonColor)
                .align(Alignment.TopEnd),
            onClick = { appViewModel.pauseGame() }
        ) {
            Icon(
                imageVector = Icons.Default.Pause,
                contentDescription = "Pause game",
                modifier = Modifier
                    .background(buttonColor),
                tint = buttonTextColor
            )
        }
        Text(
            text = gameState.value.score.toString(),
            style = MaterialTheme.typography.displayLarge,
            modifier = Modifier
                .padding(top = 24.dp)
                .align(Alignment.TopCenter),
            color = textColorPrimary,
            fontSize = 24.sp
        )
    }
}

@Composable
fun PauseScreen(appViewModel: AppViewModel = viewModel()) {
    Column(
        modifier = Modifier
            .fillMaxSize()
            .background(backColorPrimary),
        verticalArrangement = Arrangement.Center,
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        Text(
            text = "Game paused",
            style = MaterialTheme.typography.displayLarge,
            color = textColorPrimary,
            fontSize = 50.sp
        )
        Spacer(
            modifier = Modifier
                .padding(vertical = 16.dp)
                .background(backColorSecondary)
        )
        IconButton(
            onClick = {
                appViewModel.resumeGame()
            }, modifier = Modifier.size(100.dp)
        ) {
            Icon(
                imageVector = Icons.Default.PlayArrow,
                contentDescription = "Resume",
                modifier = Modifier.size(100.dp)
                    .background(backColorSecondary),
                tint = buttonTextColor
            )
        }
    }
}

@Composable
fun FirstEnterScreen(appViewModel: AppViewModel = viewModel()) {
    Column(
        modifier = Modifier
            .fillMaxSize()
            .background(backColorPrimary),
        verticalArrangement = Arrangement.Center,
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        Text(
            text = enterText,
            style = MaterialTheme.typography.displayLarge,
            color = textColorPrimary,
            fontSize = 38.sp,
            textAlign = TextAlign.Center
        )
        Spacer(
            modifier = Modifier
                .padding(vertical = 16.dp)
                .background(backColorSecondary)
        )
        IconButton(
            onClick = {
                appViewModel.startGame()
            }, modifier = Modifier.size(100.dp)
        ) {
            Icon(
                imageVector = Icons.Default.PlayArrow,
                contentDescription = "Start",
                modifier = Modifier.size(100.dp)
                    .background(backColorSecondary),
                tint = buttonTextColor
            )
        }
    }
}

class AccelerometerHandler @Inject constructor(
    private val gameThread: GameThread
) : SensorEventListener {

    /**
     * @param values[0] - наклон по оси X (вправо или влево когда экран смотрит на пользователя)
     * // infinity..0..-infinity
     * @param values[1] - наклон по оси Y (вправо или влево когда экран смотрит на пользователя)
     * // как в математике
     * @param values[2] - наклон по оси Z (от себя или на себя когда экран смотрит на пользователя)
     */
    override fun onSensorChanged(p0: SensorEvent) {
        val currentRotation = p0.values[0]
        gameThread.registerRotation(currentRotation * 4)
    }

    override fun onAccuracyChanged(p0: Sensor?, p1: Int) {

    }
}

@Module
@InstallIn(SingletonComponent::class)
object AppModule {

    @Provides
    @Singleton
    fun provideGameThread(): GameThread = GameThread()

    @Provides
    @Singleton
    fun provideSensorManager(@ApplicationContext context: Context): SensorManager =
        context.getSystemService(Context.SENSOR_SERVICE) as SensorManager


}

@HiltViewModel
class AppViewModel @Inject constructor(
    private val gameThread: GameThread,
    sensorManager: SensorManager
) : ViewModel() {

    private val _gameState = MutableStateFlow(GameState())
    val gameState = _gameState.asStateFlow()

    private val _screenState = MutableStateFlow<ScreenState>(ScreenState.FirstEnter)
    val screenState = _screenState.asStateFlow()

    init {
        val sensor = sensorManager.getDefaultSensor(Sensor.TYPE_ACCELEROMETER)
        sensorManager.registerListener(
            AccelerometerHandler(gameThread),
            sensor,
            SensorManager.SENSOR_DELAY_GAME
        )
        viewModelScope.launch(Dispatchers.Default) {
            gameThread.gameState.collect { threadGameState ->
                _gameState.value = threadGameState
            }
        }
        viewModelScope.launch(Dispatchers.Default) {
            gameThread.screenState.collect { threadScreenState ->
                _screenState.value = threadScreenState
            }
        }
    }

    fun startGame() = gameThread.startGame()

    fun pauseGame() = gameThread.pauseGame()

    fun resumeGame() = gameThread.resumeGame()

    fun restartGame() = gameThread.restartGame()

}

class Background(val offset: Float) : GameObject() {
    fun initialize() {
        bitmap = BitmapsInitializer.background
        bitmap?.let { bitmap ->
            width = bitmap.width
            height = bitmap.height
        }
        speed = 10f
    }

    fun increaseSpeed() {
        speed += 0.005f
    }
}

class Backgrounds {
    val backgrounds = listOf(Background(0f), Background(-BitmapsInitializer.insetScreenHeight.toFloat()))

    fun initialize() {
        backgrounds.forEach { background ->
            background.initialize()
        }
    }

    fun frame() {
        backgrounds.forEach { background ->
            background.y = (background.y + background.speed) % BitmapsInitializer.insetScreenHeight
            background.increaseSpeed()
        }
    }
}

class BitmapsInitializer(private val resources: Resources) {

    init {

        val backgroundWidth = resizeWidth(screenWidth)
        val backgroundHeight = insetScreenHeight + 10

        val playerWidth = resizeWidth(183)
        val playerHeight = resizeHeight(400)

        val enemyCarWidth = resizeWidth(201)
        val enemyCarHeight = resizeHeight(400)

        background = initBitmap(
            R.drawable.background,
            backgroundWidth,
            backgroundHeight,
        )

        player = initBitmap(
            R.drawable.player,
            playerWidth,
            playerHeight
        )

        enemyCar = initBitmap(
            R.drawable.enemy_car,
            enemyCarWidth,
            enemyCarHeight
        )

    }

    private fun initBitmap(
        @DrawableRes res: Int,
        width: Int,
        height: Int
    ): ImageBitmap {
        return Bitmap.createScaledBitmap(
            BitmapFactory.decodeResource(resources, res),
            width,
            height,
            false
        ).asImageBitmap()
    }

    companion object {
        var player: ImageBitmap? = null
        var enemyCar: ImageBitmap? = null
        var background: ImageBitmap? = null

        val screenWidth = Resources.getSystem().displayMetrics.widthPixels
        val screenHeight = Resources.getSystem().displayMetrics.heightPixels

        var insetScreenHeight: Int = 0

        private const val INIT_WIDTH = 1080
        private const val INIT_HEIGHT = 2040

        private fun resizeWidth(size: Int) = screenWidth * size / INIT_WIDTH
        private fun resizeHeight(size: Int) = insetScreenHeight * size / INIT_HEIGHT
        private fun resizeWidth(size: Float) = screenWidth * size / INIT_WIDTH
        private fun resizeHeight(size: Float) = insetScreenHeight * size / INIT_HEIGHT
    }
}

class EnemyCar : GameObject() {
    fun initialize() {
        bitmap = BitmapsInitializer.enemyCar
        bitmap?.let { bitmap ->
            width = bitmap.width
            height = bitmap.height
        }
        y = -getRandom(0, BitmapsInitializer.screenHeight * 10).toFloat()
        x = getRandom(width, BitmapsInitializer.screenWidth) - width.toFloat()
        speed = 15f
        setRect()
    }

    fun frame(listCars: MutableList<EnemyCar>) {
        y += speed
        increaseSpeed()
        setRect()
        if (y > BitmapsInitializer.screenHeight * 1.5f)
            reset()
        checkAnotherCarCollision(listCars)
    }

    private fun checkAnotherCarCollision(listCars: MutableList<EnemyCar>) {
        listCars.forEach { enemyCar ->
            if (hasCollision(enemyCar) && enemyCar.rect != rect)
                reset()
        }
    }

    fun reset() {
        y = -getRandom(height, BitmapsInitializer.screenHeight * 10).toFloat()
        setRect()
    }

    fun increaseSpeed() {
        speed += 0.005f
    }
}

fun Rect.intersects(rect: Rect): Boolean {
    return intersects(rect.left, rect.top, rect.right, rect.bottom)
}

open class GameObject {
    var x = 0f
    var y = 0f
    var speed = 0f
    var bitmap: ImageBitmap? = null
    var width = 0
    var height = 0
    var rect: Rect = Rect()

    open fun setRect() {
        rect.set(x.toInt(), y.toInt(), (x + width).toInt(), (y + height).toInt())
    }

    open fun hasCollision(gameObject: GameObject) = rect.intersects(gameObject.rect)

    fun getRandom(bound: Int, upperBound: Int) =
        Random(System.nanoTime()).nextInt(bound, upperBound)
}

data class GameState(
    val score: Int = 0,
    val player: Player = Player(),
    val enemies: MutableList<EnemyCar> = mutableListOf(),
    val background: Backgrounds = Backgrounds()
)

class GameThread {

    private val _gameState = MutableStateFlow(GameState())
    val gameState = _gameState.asStateFlow()

    private val _screenState = MutableStateFlow<ScreenState>(ScreenState.FirstEnter)
    val screenState = _screenState.asStateFlow()

    private var startTime: Long = 0
    private var frameTime: Long = 0
    private val neededFrameTime: Int = (1000.0 / 60.0).toInt()

    private var job: Job? = null

    private var running: Boolean = true

    private fun initialize() {
        firstInitialize()
        job = CoroutineScope(Dispatchers.Default + SupervisorJob())
            .launch(start = CoroutineStart.LAZY) {
                loop()
            }
        running = true
        job?.start()
    }

    private fun resume() {
        job = CoroutineScope(Dispatchers.Default + SupervisorJob())
            .launch(start = CoroutineStart.LAZY) {
                loop()
            }
        running = true
        job?.start()
    }

    private suspend fun loop() {
        while (running) {
            startTime = System.currentTimeMillis()

            frame()

            frameTime = System.currentTimeMillis() - startTime
            if (frameTime < neededFrameTime) {
                delay(neededFrameTime - frameTime)
            }
        }
    }

    private fun firstInitialize() = with(_gameState.value) {
        _gameState.value = copy(
            player = player.apply { initialize() },
            background = background.apply { initialize() },
            enemies = enemies.apply {
                repeat(8) {
                    add(EnemyCar().apply {
                        initialize()
                    })
                }
            }
        )
    }

    private fun frame() = with(_gameState.value) {
        _gameState.value = copy(
            score = score + 1,
            enemies = enemies.onEach { enemyCar ->
                enemyCar.frame(enemies)
                if (enemyCar.hasCollision(player))
                    end()
            },
            background = background.apply { frame() },
            player = player.apply { frame() }
        )
    }

    fun registerRotation(newSpeed: Float) = with(_gameState.value) {
        _gameState.value = copy(
            player = player.apply {
                speed = newSpeed
            }
        )
    }

    private fun stop() {
        running = false
        job = null
    }

    private fun end() {
        _screenState.value = ScreenState.Finished
        stop()
    }

    fun startGame() {
        _screenState.value = ScreenState.Running
        initialize()
    }

    fun pauseGame() {
        _screenState.value = ScreenState.Paused
        stop()
    }

    fun resumeGame() {
        _screenState.value = ScreenState.Running
        resume()
    }

    fun restartGame() = with(_gameState.value) {
        _gameState.value = copy(
            enemies = enemies.onEach { enemyCar ->
                enemyCar.reset()
            },
            player = player.apply {
                x = BitmapsInitializer.screenWidth / 2 - width / 2f
            },
            score = 0
        )
        _screenState.value = ScreenState.Running
        initialize()
    }
}

class Player : GameObject() {
    fun initialize() {
        bitmap = BitmapsInitializer.player
        bitmap?.let { bitmap ->
            width = bitmap.width
            height = bitmap.height
        }
        x = BitmapsInitializer.screenWidth / 2 - width / 2f
        y = BitmapsInitializer.screenHeight - height.toFloat()
        setRect()
    }

    fun frame() {
        if ((x - speed) > 10 && (x - speed) < (BitmapsInitializer.screenWidth - width - 10)) {
            x -= speed
            setRect()
        }
    }
}

sealed class ScreenState {
    object Running : ScreenState()
    object Paused : ScreenState()
    object Finished : ScreenState()
    object FirstEnter : ScreenState()
}

"""
    }
    
    static func enterText() -> String {
        let list = ["Welcome to street racing", "Start Game", "Start Race", "Race", "Game", "New Race", "New Game"]
        return list.randomElement() ?? list[0]
    }
}
