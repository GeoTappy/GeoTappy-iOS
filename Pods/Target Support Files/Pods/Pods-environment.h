
// To check if a library is compiled with CocoaPods you
// can use the `COCOAPODS` macro definition which is
// defined in the xcconfigs so it is available in
// headers also when they are imported in the client
// project.


// Bolts
#define COCOAPODS_POD_AVAILABLE_Bolts
#define COCOAPODS_VERSION_MAJOR_Bolts 1
#define COCOAPODS_VERSION_MINOR_Bolts 1
#define COCOAPODS_VERSION_PATCH_Bolts 3

// DMJobManager
#define COCOAPODS_POD_AVAILABLE_DMJobManager
#define COCOAPODS_VERSION_MAJOR_DMJobManager 1
#define COCOAPODS_VERSION_MINOR_DMJobManager 0
#define COCOAPODS_VERSION_PATCH_DMJobManager 0

// DMListener
#define COCOAPODS_POD_AVAILABLE_DMListener
#define COCOAPODS_VERSION_MAJOR_DMListener 1
#define COCOAPODS_VERSION_MINOR_DMListener 0
#define COCOAPODS_VERSION_PATCH_DMListener 0

// Facebook-iOS-SDK
#define COCOAPODS_POD_AVAILABLE_Facebook_iOS_SDK
#define COCOAPODS_VERSION_MAJOR_Facebook_iOS_SDK 3
#define COCOAPODS_VERSION_MINOR_Facebook_iOS_SDK 19
#define COCOAPODS_VERSION_PATCH_Facebook_iOS_SDK 0

// HockeySDK
#define COCOAPODS_POD_AVAILABLE_HockeySDK
#define COCOAPODS_VERSION_MAJOR_HockeySDK 3
#define COCOAPODS_VERSION_MINOR_HockeySDK 6
#define COCOAPODS_VERSION_PATCH_HockeySDK 1

// KLCPopup
#define COCOAPODS_POD_AVAILABLE_KLCPopup
#define COCOAPODS_VERSION_MAJOR_KLCPopup 1
#define COCOAPODS_VERSION_MINOR_KLCPopup 0
#define COCOAPODS_VERSION_PATCH_KLCPopup 0

// Debug build configuration
#ifdef DEBUG

  // SimulatorStatusMagic
  #define COCOAPODS_POD_AVAILABLE_SimulatorStatusMagic
  #define COCOAPODS_VERSION_MAJOR_SimulatorStatusMagic 1
  #define COCOAPODS_VERSION_MINOR_SimulatorStatusMagic 2
  #define COCOAPODS_VERSION_PATCH_SimulatorStatusMagic 0

#endif
