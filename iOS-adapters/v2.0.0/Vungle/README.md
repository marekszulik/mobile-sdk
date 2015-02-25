# Vungle - adapter info

## Compatibililty

| Network | Adapter version | Third party SDK version | Fyber SDK version |
|:----------:|:-------------:|:-----------------------:|:------------:|
| Vungle | 2.4.0 | 3.0.12 | 7.1 |

**Important:** *The Vungle SDK supports iOS 6 or higher.*

## Example parameters

* **name**: `Vungle`
* **settings**:
	* **SPVungleAppId**
	* **SPVungleOrientation**: `all` | `portrait` | `landscapeLeft` | `landscapeRight` | `portraitUpsideDown` | `landscape` | `allButUpsideDown`
	* **SPVungleIncentivized**: `YES` | `NO`
	* **SPVungleIncentivizedAlertTitleText**: Any string
	* **SPVungleIncentivizedAlertBodyText**: Any string
	* **SPVungleIncentivizedAlertCloseButtonText**: Any string
	* **SPVungleIncentivizedAlertContinueButtonText**: Any string


## Required frameworks

* `AdSupport.framework` (Mark as Optional to support < iOS 6.0)
* `AudioToolbox.framework`
* `AVFoundation.framework`
* `CFNetwork.framework`
* `CoreGraphics.framework`
* `CoreMedia.framework`
* `Foundation.framework`
* `libz.dylib`
* `libsqlite3.dylib`
* `MediaPlayer.framework`
* `QuartzCore.framework`
* `StoreKit.framework` (Mark as Optional to support < iOS 6.0)
* `SystemConfiguration.framework`
* `UIKit.framework`

## Required linker flags

 none
 
## Known issues
**Information from Vungle:**

**There is currently a known, but uncommon crash on iOS when users place the app in the background as the video ad experience is playing.**