//
//  SPMillenialInterstitialAdapter.h
//
//  Created on 18/02/14.
//  Copyright (c) 2014 Fyber. All rights reserved.
//

#import "SPBaseNetwork.h"
#import "SPInterstitialNetworkAdapter.h"

/**
 Implementation of Millennial Media network for Interstitial demand
 
 ## Version compatibility
 
 - Adapter version: 2.0.3
 - Fyber SDK version: 7.0.3
 - Millennial Media SDK version: 5.4.1
 
 */

@class SPMillennialNetwork;

@interface SPMillennialInterstitialAdapter : NSObject  <SPInterstitialNetworkAdapter>

@property (weak, nonatomic) SPMillennialNetwork *network;

@end
