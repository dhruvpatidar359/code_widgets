package com.example.codewidget

import android.annotation.TargetApi
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.os.Build
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetPlugin
import java.io.File

/**
 * Implementation of App Widget functionality.
 */
@TargetApi(Build.VERSION_CODES.CUPCAKE)
class QuoteWidget : AppWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        // There may be multiple widgets active, so update all of them
        for (appWidgetId in appWidgetIds) {
            val widgetData = HomeWidgetPlugin.getData(context)
            val views = RemoteViews(context.packageName, R.layout.quote_widget)
            val quote = widgetData.getString("quote","Quote")
            val author = widgetData.getString("author","- Author")
            println(author)
            val imageName = widgetData.getString("filename", null)
            println(imageName + "")
            println(" i am working there")
            if(imageName != null) {
                val imageFile = File(imageName)
                val imageExists = imageFile.exists()

                if (imageExists) {
                    val myBitmap: Bitmap = BitmapFactory.decodeFile(imageFile.absolutePath)
                    println(myBitmap)
                    views.setImageViewBitmap(R.id.widget_image, myBitmap)
                } else {
                    println("image not found!, looked @: ${imageName}")
                }

            } else {
                println("null a gaya re baba")
            }

            views.setTextViewText(R.id.quote_title,quote);
            views.setTextViewText(R.id.quote_author, "- $author")
            appWidgetManager.updateAppWidget(appWidgetId,views)
        }
    }

    override fun onEnabled(context: Context) {
        // Enter relevant functionality for when the first widget is created
    }

    override fun onDisabled(context: Context) {
        // Enter relevant functionality for when the last widget is disabled
    }
}