import java.io.File

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// Cargar variables de entorno desde el .env raíz
// NOTA: usamos parser propio porque Properties.load() trata '#' como comentario,
// lo que rompería contraseñas que contengan ese carácter.
fun loadEnv(file: File): Map<String, String> {
    if (!file.exists()) return emptyMap()
    val map = mutableMapOf<String, String>()
    file.forEachLine { line ->
        val trimmed = line.trim()
        // Ignorar líneas vacías y comentarios reales (sólo los que empiezan con #)
        if (trimmed.isEmpty() || trimmed.startsWith("#")) return@forEachLine
        val idx = trimmed.indexOf('=')
        if (idx > 0) {
            val key   = trimmed.substring(0, idx).trim()
            val value = trimmed.substring(idx + 1).trim()
            map[key] = value
        }
    }
    return map
}

val envFile = File(project.projectDir.parentFile.parentFile, ".env")
val env = loadEnv(envFile)

    namespace = "com.clifarma.app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.clifarma.app"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            val keystorePath = env["ANDROID_KEYSTORE_PATH"]
            if (keystorePath != null) {
                storeFile = file(keystorePath)
                storePassword = env["ANDROID_STORE_PASSWORD"]
                keyAlias = env["ANDROID_KEY_ALIAS"]
                keyPassword = env["ANDROID_KEY_PASSWORD"]
            }
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
        }
    }
}

flutter {
    source = "../.."
}
