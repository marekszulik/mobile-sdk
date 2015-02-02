# Flurry for Advertisers - adapter info

***<font color='red'>This is recommended update</font>***

## Compatibililty

| Network | Adapter version | Third party SDK version | Fyber SDK version |
|:----------:|:-------------:|:-----------------------:|:------------:|
| Flurry for Advertisers | 2.4.0 | 6.0.0 | 7.0.3 |

## Example parameters

* **name**: `FlurryAppCircleClips`
* **settings**:
	* **SPFlurryAdSpaceInterstitial**
	* **SPFlurryAdSpaceVideo**
	* **SPFlurryApiKey**
	* **SPFlurryEnableTestAds**: `YES` | `NO`
	* **SPFlurryLogLevel**: `criticalOnly` | `none` | `debug` | `all`
	
## Required frameworks

* `AdSupport.framework` (Mark as Optional to support < iOS 6.0)
* `CoreGraphics.framework`
* `Foundation.framework`
* `MediaPlayer.framework`
* `Security.framework`
* `StoreKit.framework` (Mark as Optional to support < iOS 6.0)
* `SystemConfiguration.framework`
* `UIKit.framework`
* `libz.dylib` (as of Flurry SDK version 5.0 this library is required)

## Required linker flags

_none_

## Known issues
none