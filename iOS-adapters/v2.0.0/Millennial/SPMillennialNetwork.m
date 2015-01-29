//
//  SPMillennialNetwork.m
//
//  Created on 18/02/14.
//  Copyright (c) 2014 Fyber. All rights reserved.
//

#import "SPMillennialNetwork.h"
#import "SPMillennialInterstitialAdapter.h"
#import "SPSemanticVersion.h"
#import "SPLogger.h"
#import <MillennialMedia/MMSDK.h>

static NSString *const SPMillennialApId = @"SPMillennialApid";

// Adapter versioning - Remember to update the header
static const NSInteger SPMillennialVersionMajor = 2;
static const NSInteger SPMillennialVersionMinor = 0;
static const NSInteger SPMillennialVersionPatch = 3;

@interface SPMillennialNetwork()

@property (strong, nonatomic) SPMillennialInterstitialAdapter *interstitialAdapter;

@end

@implementation SPMillennialNetwork

@synthesize interstitialAdapter;

+ (SPSemanticVersion *)adapterVersion
{
    return [SPSemanticVersion versionWithMajor:SPMillennialVersionMajor minor:SPMillennialVersionMinor patch:SPMillennialVersionPatch];
}

- (id)init
{
    self = [super init];
    if (self) {
        self.interstitialAdapter = [[SPMillennialInterstitialAdapter alloc] init];
    }
    return self;
}

- (BOOL)startSDK:(NSDictionary *)data
{
    NSString *apId = data[SPMillennialApId];
    
    if (NSFoundationVersionNumber < NSFoundationVersionNumber_iOS_6_0) {
        SPLogError(@"%@ only supports iOS 6 or later",self.name);
        return NO;
    }
    
    if (!apId.length) {
        SPLogError(@"Could not start %@ Network. %@ empty or missing.", self.name, SPMillennialApId);
        return NO;
    }
    
    self.apid = apId;
    [MMSDK initialize];

    return YES;
}

@end
