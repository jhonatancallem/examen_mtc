import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("android/key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    namespace = "com.jhonatandev.examenmtc"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    // --- EL CAMBIO ESTÁ AQUÍ ---
    defaultConfig {
        // La línea 'applicationId' ahora está en su lugar correcto
        applicationId = "com.jhonatandev.examenmtc"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            keyAlias = "my-key-alias" // <-- OJO: Usa tu alias real aquí
            keyPassword = "91890000"
            // ¡IMPORTANTE! Usa la ruta absoluta y correcta a tu archivo.
            // Usa barras inclinadas '/' incluso en Windows.
            storeFile = file("C:/claves/mtc/my-release-key.jks") // <-- CAMBIA ESTO por tu ruta real
            storePassword = "91890000"
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
            ndk {
                debugSymbolLevel = "NONE"
            }
        }
    }
}

flutter {
    source = "../.."
}