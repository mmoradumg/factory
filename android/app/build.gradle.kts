import java.util.Properties

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystorePropertiesFile.inputStream().use { keystoreProperties.load(it) }
}

fun signingPassword(environmentKeyProperty: String): String {
    val environmentKey = keystoreProperties.getProperty(environmentKeyProperty)
        ?: throw GradleException("Missing $environmentKeyProperty in key.properties")
    return System.getenv(environmentKey)
        ?: throw GradleException("Missing $environmentKey environment variable for release signing")
}

// CI debug builds must never require release signing material.
// A release is intentionally rejected if the keystore or its secrets are missing.
val releaseSigningKeys = listOf("keyAlias", "storeFile", "keyPasswordEnv", "storePasswordEnv")
val releaseSigningConfigured =
    keystorePropertiesFile.isFile &&
        releaseSigningKeys.all { !keystoreProperties.getProperty(it).isNullOrBlank() } &&
        listOf("keyPasswordEnv", "storePasswordEnv").all {
            val environmentKey = keystoreProperties.getProperty(it)
            !System.getenv(environmentKey).isNullOrBlank()
        }

plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.murad85.factoryaudit"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.murad85.factoryaudit"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        if (releaseSigningConfigured) {
            create("release") {
                keyAlias = keystoreProperties.getProperty("keyAlias")
                keyPassword = signingPassword("keyPasswordEnv")
                storeFile = keystoreProperties.getProperty("storeFile")?.let(::file)
                    ?: throw GradleException("Missing storeFile in key.properties")
                storePassword = signingPassword("storePasswordEnv")
            }
        }
    }

    buildTypes {
        release {
            if (releaseSigningConfigured) {
                signingConfig = signingConfigs.getByName("release")
            }
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}

/*
 * Fail closed for release outputs. Android's release tasks can otherwise
 * proceed without a signing config, while debug CI never needs release keys.
 */
tasks.configureEach {
    val producesRelease =
        (name.startsWith("assemble") || name.startsWith("bundle")) &&
            name.endsWith("Release")
    if (producesRelease) {
        doFirst {
            if (!releaseSigningConfigured) {
                throw GradleException(
                    "Release signing is not configured. Provide android/key.properties " +
                        "and its referenced environment variables; unsigned releases are forbidden."
                )
            }
        }
    }
}
