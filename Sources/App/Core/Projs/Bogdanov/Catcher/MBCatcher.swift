//
//  File.swift
//  
//
//  Created by admin on 28.06.2023.
//

import Foundation

struct MBCatcher: FileProviderProtocol {
    static var fileName = "MBCatcher.kt"
    
    static func fileContent(
        packageName: String,
        uiSettings: UISettings
    ) -> String {
        return """
package \(packageName).presentation.fragments.main_fragment


import android.content.res.Resources
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.graphics.Rect
import android.view.MotionEvent
import androidx.annotation.DrawableRes
import androidx.compose.foundation.Canvas
import androidx.compose.foundation.Image
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.navigationBarsPadding
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Refresh
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.Icon
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.State
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.ui.Alignment
import androidx.compose.ui.ExperimentalComposeUiApi
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.scale
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.ImageBitmap
import androidx.compose.ui.graphics.asImageBitmap
import androidx.compose.ui.input.pointer.pointerInteropFilter
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.font.FontStyle
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import \(packageName).R
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.Job
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.delay
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch
import kotlin.random.Random

val textColorPrimary = Color(0xFF\(uiSettings.textColorPrimary ?? "FFFFFF")
val buttonColorPrimary = Color(0xFF\(uiSettings.buttonColorPrimary ?? "FFFFFF")
val buttonTextColorPrimary = Color(0xFF\(uiSettings.buttonTextColorPrimary ?? "FFFFFF")

@Composable
fun LoadingScreen() {
    ComposeBack(image = R.drawable.background)
    Column(modifier = Modifier
        .fillMaxSize()
        .padding(4.dp),
        verticalArrangement = Arrangement.Center,
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        CircularProgressIndicator(modifier = Modifier.padding(8.dp), color = textColorPrimary)
        Text(
            text = stringResource(R.string.loading),
            style = TextStyle(
                color = textColorPrimary,
                fontSize = 24.sp
            )
        )
    }
}

@OptIn(ExperimentalComposeUiApi::class)
@Composable
fun GameCanvas(
    viewModel: MainViewModel
) {
    val state = viewModel.state.collectAsState()

    Box(modifier = Modifier.fillMaxSize()) {
        Canvas(
            modifier = Modifier
                .fillMaxSize()
                .pointerInteropFilter { event ->
                    when (event.action) {
                        MotionEvent.ACTION_DOWN -> {
                            viewModel.moveCart(event.x)
                            true
                        }

                        MotionEvent.ACTION_MOVE -> {
                            viewModel.moveCart(event.x)
                            true
                        }

                        else -> false
                    }
                },
        ) {
            drawImage(state.value.background.bitmap, Offset(0f, 0f))
            state.value.apples.forEach { apple ->
                drawImage(apple.bitmap, Offset(apple.x, apple.y))
            }
            drawImage(state.value.cart.bitmap, Offset(state.value.cart.x, state.value.cart.y))
        }

        Text(
            text = stringResource(R.string.score_counter, state.value.score),
            fontStyle = FontStyle.Italic,
            color = textColorPrimary,
            fontSize = 22.sp,
            modifier = Modifier
                .navigationBarsPadding()
                .align(Alignment.TopEnd)
                .padding(top = 32.dp, end = 16.dp)
        )

        Text(
            text = stringResource(R.string.attempts_remaining, state.value.attempts),
            fontStyle = FontStyle.Italic,
            color = textColorPrimary,
            fontSize = 18.sp,
            modifier = Modifier
                .navigationBarsPadding()
                .align(Alignment.TopStart)
                .padding(top = 32.dp, start = 16.dp)
        )
    }
}

@Composable
fun EndGameScreen(viewModel: MainViewModel, state: State<GameState>) {
    ComposeBack(image = R.drawable.background)
    Column(
        modifier = Modifier
            .fillMaxSize()
            .padding(8.dp),
        verticalArrangement = Arrangement.SpaceAround,
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        Column(
            verticalArrangement = Arrangement.Center,
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            Text(
                modifier = Modifier.padding(4.dp),
                text = stringResource(R.string.you_lost),
                style = TextStyle(
                    color = textColorPrimary,
                    fontSize = 42.sp,
                    fontWeight = FontWeight.Black
                )
            )
            Text(
                modifier = Modifier.padding(4.dp),
                text = stringResource(R.string.score, state.value.score),
                style = TextStyle(
                    color = textColorPrimary,
                    fontSize = 36.sp,
                    fontWeight = FontWeight.Black
                )
            )
        }
        Button(
            modifier = Modifier
                .scale(1.25f)
            ,
            shape = RoundedCornerShape(8.dp),
            colors = ButtonDefaults.buttonColors(containerColor = buttonColorPrimary),
            onClick = { viewModel.restart() }
        ) {
            Icon(
                modifier = Modifier.padding(end = 2.dp),
                imageVector = Icons.Default.Refresh,
                tint = buttonTextColorPrimary,
                contentDescription = stringResource(R.string.restart_description)
            )
            Text(
                text = stringResource(R.string.restart),
                color = buttonTextColorPrimary,
                        fontSize = 20.sp
            )
        }
    }
}

class Apple : GameObject() {

    fun initialize(){
        bitmap = Bitmaps.apple
        width = bitmap.width
        height = bitmap.height
        x = getRandom(Bitmaps.screenWidth - width).toFloat()
        y = 0 - height.toFloat() - getRandom(Bitmaps.screenHeight * 10)
        speed = 20f
    }

    fun isOutOfBounds() = y > Bitmaps.screenHeight
}

class Background : GameObject() {
    fun initialize() {
        bitmap = Bitmaps.background
        width = bitmap.width
        height = bitmap.height
    }
}

object Bitmaps {
    lateinit var res: Resources
    lateinit var cart: ImageBitmap
    lateinit var apple: ImageBitmap
    lateinit var background: ImageBitmap

    fun initialize(resources: Resources) {
        res = resources

        val cartWidth = resizeWidth(230)
        val cartHeight = resizeHeight(230)

        val appleWidth = resizeWidth(130)
        val appleHeight = resizeWidth(130)

        val backgroundWidth = resizeWidth(screenWidth)
        val backgroundHeight = resizeHeight(screenHeight)

        background = initBitmap(
            R.drawable.background,
            backgroundWidth,
            backgroundHeight,
        )
        cart = initBitmap(R.drawable.cart, cartWidth, cartHeight)
        apple = initBitmap(R.drawable.`object`, appleWidth, appleHeight)

    }

    private fun initBitmap(
        @DrawableRes res: Int,
        width: Int,
        height: Int
    ): ImageBitmap {
        return Bitmap.createScaledBitmap(
            BitmapFactory.decodeResource(Bitmaps.res, res),
            width,
            height,
            false
        ).asImageBitmap()
    }

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

class Cart : GameObject() {

    fun initialize() {
        bitmap = Bitmaps.cart
        width = bitmap.width
        height = bitmap.height

        x = Bitmaps.screenWidth / 2f - width / 2f
        y = Bitmaps.screenHeight - height * 1.5f

        setRect()
    }
}

fun Rect.intersects(rect: Rect): Boolean {
    return intersects(rect.left, rect.top, rect.right, rect.bottom)
}

open class GameObject {
    var x = 0f
    var y = 0f
    var speed = 0f
    lateinit var bitmap: ImageBitmap
    var width = 0
    var height = 0
    var rect: Rect = Rect()

    open fun setRect() {
        rect.set(x.toInt(), y.toInt(), (x + width).toInt(), (y + height).toInt())
    }

    open fun hasCollision(gameObject: GameObject) = rect.intersects(gameObject.rect)

    fun getRandom(bound: Int) = Random.nextInt(0, bound)
}

data class GameState(
    val score: Long = 0,
    val cart: Cart = Cart(),
    val apples: List<Apple> = listOf(),
    val background: Background = Background(),
    val screen: Screen = Screen.Loading,
    val time: Long = System.currentTimeMillis(),
    val attempts: Int = 3
)

class MainViewModel : ViewModel() {

    private var job: Job? = null

    private var startTime: Long = 0
    private var frameTime: Long = 0
    private val neededFrameTime: Int = (1000.0 / 60.0).toInt()

    private val _state = MutableStateFlow(GameState())
    val state = _state.asStateFlow()

    private var running: Boolean = true
    private var currentScore: Long = 0

    private fun play() {
        if (job?.isActive != true) {
            job = viewModelScope.launch(Dispatchers.Default + SupervisorJob()) {
                initializeObjects()
                _state.value = _state.value.copy(screen = Screen.Running)

                while (running) {
                    startTime = System.currentTimeMillis()

                    moveAppleDown()
                    checkCollision()
                    checkAppleOutOfBounds()

                    _state.value = _state.value.copy(
                        score = currentScore,
                        time = System.currentTimeMillis(),
                        screen = if (running) Screen.Running else Screen.Finished
                    )

                    frameTime = System.currentTimeMillis() - startTime
                    if (frameTime < neededFrameTime) {
                        delay(neededFrameTime - frameTime)
                    }
                }
            }
        }
    }


    fun initialize(res: Resources){
        viewModelScope.launch(Dispatchers.Default) {
            Bitmaps.initialize(resources = res)
            play()
        }
    }

    private fun initializeObjects() = with(_state.value) {
        _state.value = _state.value.copy(
            cart = cart.also { cart -> cart.initialize() },
            background = background.also { background -> background.initialize() },
        )
        spawnApples()
    }

    fun restart() {
        _state.value = _state.value.copy(
            apples = arrayListOf(),
            background = Background(),
            cart = Cart(),
            score = 0L,
            attempts = 3,
            screen = Screen.Loading
        )
        currentScore = 0
        running = true
        play()
    }

    private fun spawnApples() = with(_state.value) {
        val applesFilled = mutableListOf<Apple>()
        repeat(7) {
            val apple = Apple().also { it.initialize() }
            applesFilled += apple
        }
        _state.value = _state.value.copy(
            apples = applesFilled.toList()
        )
    }

    private fun moveAppleDown() = with(_state.value) {
        apples.forEach { apple ->
            apples[apples.indexOf(apple)].y += apple.speed
            apples[apples.indexOf(apple)].setRect()
            _state.value = _state.value.copy(
                apples = apples
            )
        }
    }

    private fun checkCollision() = with(_state.value) {
        apples.forEach { apple ->
            if (cart.hasCollision(apple)) {
                currentScore++
                moveAppleRandomAndIncreaseSpeed(apple)
            }
        }
    }

    private fun checkAppleOutOfBounds() = with(_state.value) {
        apples.forEach { apple ->
            if (apple.isOutOfBounds()) {
                val attemptsRemaining = _state.value.attempts - 1
                _state.value = _state.value.copy(
                    attempts = attemptsRemaining
                )
                moveAppleRandom(apple)
                if (attemptsRemaining <= 0) {
                    _state.value = _state.value.copy(
                        screen = Screen.Finished
                    )
                    running = false
                    job?.cancel()
                }
            }
        }
    }

    private fun moveAppleRandom(apple: Apple) = with(_state.value){
        apples[apples.indexOf(apple)].y = 0f - apple.height - apple.getRandom(Bitmaps.screenHeight * 3)
        apples[apples.indexOf(apple)].x = apple.getRandom(Bitmaps.screenWidth - apple.width).toFloat()
        _state.value = _state.value.copy(
            apples = apples
        )
    }

    private fun moveAppleRandomAndIncreaseSpeed(apple: Apple) = with(_state.value){
        apples[apples.indexOf(apple)].y = 0f - apple.height - apple.getRandom(Bitmaps.screenHeight * 3)
        apples[apples.indexOf(apple)].x = apple.getRandom(Bitmaps.screenWidth - apple.width).toFloat()
        apples[apples.indexOf(apple)].speed += 0.15f
        _state.value = _state.value.copy(
            apples = apples
        )
    }

    fun moveCart(posX: Float) = with(_state.value){
        _state.value = _state.value.copy(
            cart = cart.also { cart ->
                cart.x = posX - cart.width / 2
                cart.setRect()
            }
        )
    }
}

sealed interface Screen {
    object Running : Screen
    object Loading : Screen
    object Finished : Screen
}

@Composable
fun ComposeBack(image: Int) {
    val res = LocalContext.current.resources
    val back by remember {
        mutableStateOf(
            Bitmap.createScaledBitmap(
                BitmapFactory.decodeResource(
                    res,
                    image
                ), res.displayMetrics.widthPixels, res.displayMetrics.heightPixels, false
            ).asImageBitmap()
        )
    }
    Image(bitmap = back, contentDescription = null, contentScale = ContentScale.FillBounds)
}
"""
    }
}
