# Google Map Integration
## Dependencies
```yaml
    google_maps_flutter: ^2.6.1 # for displaying map
    location: ^6.0.2 # getting users current location
    flutter_polyline_points: ^2.0.0 # get polyline coordinates between two markers. 
```


## Android Configurations

### Updating `Project level build.gradle` file
   - set kotlin_version as latest.
   - example: 
        ```gradle
            buildscript{
                ext.kotlin_version = "1.9.10" // at the time of documenting, i used version is 1.9.10
                 repositories {
                    google()
                    mavenCentral()
                }
                dependencies{
                    classpath 'com.android.tools.build:gradle:7.3.0'
                    classpath "org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlin_version"
                }
            }
        ```
### Updating `App-level build.gradle` file
   - set `minSdkVersion` as 21 or newer.
   - example
   
        ```gradle
            defaultConfig {
                applicationId "your app id"
                minSdkVersion 21 // update this
                targetSdkVersion flutter.targetSdkVersion
                versionCode flutterVersionCode.toInteger()
                versionName flutterVersionName
            }
        ```
### Update `AndroidManifest.xml` file
   - add user permissions for accessing current location of the user. 
    
        ```xml
        <uses-permission android:name="android.permission.FOREGROUND_SERVICE" />
        <uses-permission android:name="android.permission.ACCESS_BACKGROUND_LOCATION"/>
        ```

   - add `GOOGLE MAP API KEY`. 
        ```xml
        <meta-data android:name="com.google.android.geo.API_KEY"
         android:value="YOUR KEY HERE" />
        ```
 

## iOS Configurations
- add location permission.
    ```
    <string>NSLocationWhenInUseUsageDescription</string>
	<key>Want to display location on map, and track it.</key>
    <string>NSLocationAlwaysAndWhenInUseUsageDescription</string>
	<key>Want to display location on map, and track it.</key>
    ```
- update `GOOGLE MAP API KEY` on `appDeligate.swift` file
    ```swift
    import UIKit
    import Flutter
    import GoogleMaps //add this line

    @UIApplicationMain
    @objc class AppDelegate: FlutterAppDelegate {
      override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
      ) -> Bool {
        GMSServices.provideAPIKey("YOUR KEY HERE") //also add this line
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
      }
    }

    ```

## Reference:
[Flutter Google Maps Tutorial | Location Tracking, Maps, Markers, Polylines, Directions API](https://www.youtube.com/watch?v=M7cOmiSly3Q)