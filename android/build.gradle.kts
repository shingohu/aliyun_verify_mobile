group = "com.shingo.aliyun_verify_mobile"
version = "1.0"
apply(from = "lib_aar_include.gradle")

buildscript {
    repositories {
        google()
        mavenCentral()
        maven { url  = uri("https://jitpack.io") }
        maven {
            url = uri("https://maven.aliyun.com/repository/public")
        }
    }

    dependencies {
        classpath("com.android.tools.build:gradle:8.11.1")
    }
}

rootProject.allprojects {
    repositories {
        google()
        mavenCentral()
        maven {
            url = uri(project(":aliyun_verify_mobile").projectDir.path + "/build")
        }
        maven { url  = uri("https://jitpack.io") }
        maven {
            url = uri("https://maven.aliyun.com/repository/public")
        }
    }
}

plugins {
    id("com.android.library")
}

android {
    namespace = "com.shingo.aliyun_verify_mobile"

    compileSdk = 36

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        minSdk = 24
    }

}

dependencies {

}
