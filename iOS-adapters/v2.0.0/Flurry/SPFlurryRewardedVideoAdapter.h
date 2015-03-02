//
//  SPFlurryRewardedVideoAdapter.h
//
//  Created on 6/17/13.
//  Copyright (c) 2011-2014 Fyber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPRewardedVideoNetworkAdapter.h"
#import "SPFlurryNetwork.h"
#import "FlurryAdInterstitialDelegate.h"

/**
 Implementation of Flurry Ads network for Rewarded Video demand
 
 ## Version compatibility
 
 - Adapter version: 2.5.0
 
 */

@class SPFlurryAppCircleClipsNetwork;

@interface SPFlurryAppCircleClipsRewardedVideoAdapter : NSObject<SPRewardedVideoNetworkAdapter, FlurryAdInterstitialDelegate>

@property (nonatomic, weak) SPFlurryAppCircleClipsNetwork *network;

@end
