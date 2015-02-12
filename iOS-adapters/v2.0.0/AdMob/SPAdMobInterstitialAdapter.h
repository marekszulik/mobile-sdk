//
//  SPAdMobInterstitialAdapter.h
//
//  Created on 01/04/14.
//  Copyright (c) 2014 Fyber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPInterstitialNetworkAdapter.h"

@class SPAdMobNetwork;

/**
 Implementation of AdMob network for interstitials demand
 
 ## Version compatibility
 
 - Adapter version: 2.1.0

 */

#if __IPHONE_OS_VERSION_MIN_REQUIRED < 60000
#error AdMob requires deployment target of 6.0 or higher
#endif

@interface SPAdMobInterstitialAdapter : NSObject<SPInterstitialNetworkAdapter>

@property (nonatomic, weak) SPAdMobNetwork *network;
@property (nonatomic, strong) NSArray *testDevices;

@end
