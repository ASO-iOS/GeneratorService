//
//  File.swift
//  
//
//  Created by admin on 26.05.2023.
//

import Foundation

struct AndroidAppConstant {
    static func whiteAsoConstant(packageName: String) -> String {
        return """
package \(packageName).constant

import android.graphics.Bitmap
import android.graphics.BitmapFactory
import androidx.compose.foundation.Image
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.ui.graphics.asImageBitmap
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.platform.LocalContext
import java.util.*

object Constant {
    const val SHARED_PREFERENCE = "SHARED_PREFERENCE"
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

fun getRandom(min: Int, max: Int): Int {
    return Random().nextInt(max - min + 1) + min
}
"""
    }
}
