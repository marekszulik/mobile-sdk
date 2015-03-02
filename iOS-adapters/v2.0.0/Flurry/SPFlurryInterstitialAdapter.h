//
//  SPFlurryInterstitialAdapter.m
//
//  Copyright (c) 2014 Fyber. All rights reserved.
//

#import "SPFlurryNetwork.h"
#import "FlurryAdInterstitial.h"

/**
 Implementation of Flurry Ads network for Interstitial demand
 
 ## Version compatibility
 
 - Adapter version: 2.5.0

 */

@class SPFlurryInterstitialAdapter;

@interface SPFlurryAppCircleClipsInterstitialAdapter : NSObject<SPInterstitialNetworkAdapter, FlurryAdInterstitialDelegate>

@property (weak, nonatomic) SPFlurryAppCircleClipsNetwork *network;

@end
