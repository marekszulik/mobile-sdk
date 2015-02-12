//
//  SPAdMobNetwork.m
//
//  Created on 01/04/14.
//  Copyright (c) 2014 Fyber. All rights reserved.
//

#import <GoogleMobileAds/GoogleMobileAds.h>

#import "SPAdMobNetwork.h"
#import "SPAdMobInterstitialAdapter.h"
#import "SPSemanticVersion.h"
#import "SPLogger.h"


// Adapter versioning - Remember to update the header
static const NSInteger SPAdMobVersionMajor = 2;
static const NSInteger SPAdMobVersionMinor = 1;
static const NSInteger SPAdMobVersionPatch = 0;

static NSString *const SPAdMobCoppaCompliance = @"SPAdMobIsCOPPACompliant";

static NSString *const SPAdMobTestDevices = @"SPAdMobTestDevices";

@interface SPAdMobNetwork ()

@end

@implementation SPAdMobNetwork

@synthesize interstitialAdapter = _interstitialAdapter;

#pragma mark - Class Methods

+ (SPSemanticVersion *)adapterVersion
{
    return [SPSemanticVersion versionWithMajor:SPAdMobVersionMajor minor:SPAdMobVersionMinor patch:SPAdMobVersionPatch];
}


#pragma mark - Initialization

- (id)init
{
    self = [super init];
    if (self) {
        _coppaComplicanceStatus = SPAdmobCoppaComplianceUnknown;
        _interstitialAdapter = [[SPAdMobInterstitialAdapter alloc] init];
    }
    return self;
}

- (BOOL)startSDK:(NSDictionary *)data
{
    if (data[SPAdMobCoppaCompliance]) {
        BOOL isCOPPACompliant = [data[SPAdMobCoppaCompliance] boolValue];
        self.coppaComplicanceStatus = isCOPPACompliant ? SPAdmobCoppaComplianceEnabled : SPAdmobCoppaComplianceDisabled;
    }
    self.testDevices = data[SPAdMobTestDevices];

    return YES;
}

@end
