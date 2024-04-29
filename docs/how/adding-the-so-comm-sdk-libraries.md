# Adding the SO Comm SDK libraries your application

This guide explains how to add the
[SO Comm Outside API Library](../reference/SDK/index.html) and the
[SO Comm MediaClient](../reference/MediaClient/index.html)
to your Android application.


## Adding the Swarovski Optic Maven repo

You need to configure a new repository to fetch the SDK libraries.

For the Groovy DSL this can be done in your root project's `settings.gradle`
file. Add the following lines to include the Swarovski Optik maven repository
for all your modules:

```groovy
dependencyResolutionManagement {
    [...]
    repositories {
        [...]
        maven { url "https://repo.swarovskioptik.com/repository/maven-swarovski-optik/" }
    }
}
```

For the newer Kotlin DSL you must add the following to the `settings.gradle.kts`:

```Kotlin
dependencyResolutionManagement {
    [...]
    repositories {
        [...]
        maven(url = uri("https://repo.swarovskioptik.com/repository/maven-swarovski-optik/"))
    }
}
```


## Adding the SO Comm Outside API

After the repository has been added, you can add the dependency like any other
gradle/maven dependency in your module/app level `build.gradle` file:

```groovy
dependencies {
    implementation "com.swarovskioptik.comm:SOCommOutsideAPI:[CURRENT_LIBRARY_VERSION]"
    [...]
}
```

Replace the term `[CURRENT_LIBRARY_VERSION]` with the current library version.
See for [Releases of the SO Comm SDK](../ref/releases.md) for details.


If your project uses the Kotlin DSL, use the following snippets for the
module/app level `build.gradle.kts`:

```Kotlin
dependencies {
    implementation("com.swarovskioptik.comm:SOCommOutsideAPI:[CURRENT_LIBRARY_VERSION]")
    [...]
}
```


## Adding the SO Comm MediaClient

The SO Comm MediaClient is a library to download videos and pictures from the
AX Visio the smartphone. E.g. you can use it to download a photo that a user
has taken while the OpenAPI was used. Adding the MediaClient to your
Android application is straight forward.

For the Groovy DSL add the follwing line in the module/app level `build.gradle`
file:

```groovy
dependencies {
    implementation "com.swarovskioptik.comm:SOCommMediaClient:[CURRENT_LIBRARY_VERSION]"
    [...]
}
```

For the Kotlin DSL add the following line in the module/app level
`build.gradle.kts` file:

```Kotlin
dependencies {
    implementation("com.swarovskioptik.comm:SOCommMediaClient:[CURRENT_LIBRARY_VERSION]")
    [...]
}
```
