//
// SPVungleAdapter.h
//
// Created on 5/30/13.
// Copyright 2011-2013 Fyber. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <VungleSDK/VungleSDK.h>
#import "SPRewardedVideoNetworkAdapter.h"

@class SPVungleNetwork;

/**
 Implementation of Vungle network for Rewarded Video demand
 
 ## Version compatibility
 
 - Adapter version: 2.4.0
 
 */

@interface SPVungleRewardedVideoAdapter : NSObject<SPRewardedVideoNetworkAdapter, VungleSDKDelegate>

@property (nonatomic, weak) SPVungleNetwork *network;

@end
