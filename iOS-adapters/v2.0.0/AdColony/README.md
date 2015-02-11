# AdColony  - adapter info

***<font color='red'>This is a recommended update</font>***

## Compatibililty

| Network | Adapter version | Third party SDK version | Fyber SDK version |
|:----------:|:-------------:|:-----------------------:|:------------:|
| AdColony | 2.1.4 | 2.4.13 | 7.0.3 + |

## Example parameters

* **name**: `AdColony`
* **settings**:
	* **SPAdColonyAppId**
	* **SPAdColonyInterstitialZoneId**
	* **SPAdColonyV4VCZoneId**
	
## Required frameworks

* `libz.1.2.5.dylib`
* `AdColony.framework`
* `AdSupport.framework` (Mark as Optional to support < iOS 6.0)
* `AudioToolbox.framework`
* `AVFoundation.framework`
* `CoreGraphics.framework`
* `CoreMedia.framework`
* `CoreTelephony.framework`
* `EventKit.framework`
* `EventKitUI.framework`
* `MediaPlayer.framework`
* `MessageUI.framework`
* `QuartzCore.framework`
* `Social.framework` (Mark as Optional to support < iOS 6.0)
* `StoreKit.framework` (Mark as Optional to support < iOS 6.0)
* `SystemConfiguration.framework`
         
## Required linker flags
*  `ObjC`
*  `objc-arc`