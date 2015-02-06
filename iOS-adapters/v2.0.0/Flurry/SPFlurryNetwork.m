//
//  SPProviderFlurry.m
//
//  Created on 02/01/14.
//  Copyright (c) 2014 Fyber. All rights reserved.
//

#import "SponsorPaySDK.h"

#import "SPFlurryNetwork.h"
#import "SPLogger.h"
#import "Flurry.h"
#import "SPSemanticVersion.h"
#import "SPTPNGenericAdapter.h"
#import "FlurryAds.h"
#import "FlurryAdInterstitial.h"

static NSString *const SPProviderName = @"SPProviderName";
static NSString *const SPFlurryApiKey = @"SPFlurryApiKey";
static NSString *const SPFlurryLogLevel = @"SPFlurryLogLevel";
static NSString *const SPFlurryEnableTestAds = @"SPFlurryEnableTestAds";

static NSString *const SPFlurryLogLevelNone = @"none";
static NSString *const SPFlurryLogLevelCriticalOnly = @"criticalOnly";
static NSString *const SPFlurryLogLevelDebug = @"debug";
static NSString *const SPFlurryLogLevelAll = @"all";

// Adapter versioning - Remember to update the header
static const NSInteger SPFlurryVersionMajor = 2;
static const NSInteger SPFlurryVersionMinor = 4;
static const NSInteger SPFlurryVersionPatch = 1;


static NSString *const SPFlurryRewardedVideoAdapterClassName = @"SPFlurryAppCircleClipsRewardedVideoAdapter";
static NSString *const SPFlurryInterstitialAdapterClassName = @"SPFlurryAppCircleClipsInterstitialAdapter";

@interface SPFlurryAppCircleClipsNetwork ()


@property (nonatomic, assign, readwrite) SPNetworkSupport supportedServices;
@property (nonatomic, strong) id<SPTPNVideoAdapter> rewardedVideoAdapter;
@property (nonatomic, strong) id<SPInterstitialNetworkAdapter> interstitialAdapter;

@end

@implementation SPFlurryAppCircleClipsNetwork

@synthesize supportedServices;
@synthesize rewardedVideoAdapter;
@synthesize interstitialAdapter;

#pragma mark - Class Methods

+ (SPSemanticVersion *)adapterVersion
{
    return [SPSemanticVersion versionWithMajor:SPFlurryVersionMajor minor:SPFlurryVersionMinor patch:SPFlurryVersionPatch];
}


#pragma mark - Initialization

- (instancetype)init
{
    self = [super init];

    if (self) {
        Class InterstitialAdapterClass = NSClassFromString(SPFlurryInterstitialAdapterClassName);
        if (InterstitialAdapterClass) {
            self.interstitialAdapter = [[InterstitialAdapterClass alloc] init];
        }
    }

    return self;
}

- (BOOL)startSDK:(NSDictionary *)data
{
    NSString *apiKey = data[SPFlurryApiKey];
    if (!apiKey.length) {
        SPLogError(@"Could not start %@ Provider. %@ empty or missing.", self.name, SPFlurryApiKey);
        return NO;
    }
    NSString *logLevel = data[SPFlurryLogLevel];
    if (logLevel.length) {
        [Flurry setLogLevel:[self flurryLogLevel:logLevel]];
    }
    [Flurry startSession:apiKey];
    [Flurry addOrigin:@"SponsorPayIOS" withVersion:[SponsorPaySDK versionString]];

    BOOL testAdsEnabled = [(NSNumber *)data[SPFlurryEnableTestAds] boolValue];
    [FlurryAds enableTestAds:testAdsEnabled];
    return YES;
}

- (void)startRewardedVideoAdapter:(NSDictionary *)data
{
    Class RewardedVideoAdapterClass = NSClassFromString(SPFlurryRewardedVideoAdapterClassName);
    if (!RewardedVideoAdapterClass) {
        return;
    }
    
    id<SPRewardedVideoNetworkAdapter> flurryRewardedVideoAdapter = [[RewardedVideoAdapterClass alloc] init];
    SPTPNGenericAdapter *flurryRewardedVideoAdapterWrapper = [[SPTPNGenericAdapter alloc] initWithVideoNetworkAdapter:flurryRewardedVideoAdapter];
    flurryRewardedVideoAdapter.delegate = flurryRewardedVideoAdapterWrapper;

    self.rewardedVideoAdapter = flurryRewardedVideoAdapterWrapper;
    [super startRewardedVideoAdapter:data];
}


#pragma mark - Private

- (FlurryLogLevel)flurryLogLevel:(NSString *)logLevel
{
    if ([logLevel isEqualToString:SPFlurryLogLevelNone]) {
        return FlurryLogLevelNone;
    } else if ([logLevel isEqualToString:SPFlurryLogLevelCriticalOnly]) {
        return FlurryLogLevelCriticalOnly;
    } else if ([logLevel isEqualToString:SPFlurryLogLevelDebug]) {
        return FlurryLogLevelDebug;
    } else if ([logLevel isEqualToString:SPFlurryLogLevelAll]) {
        return FlurryLogLevelAll;
    }
    return FlurryLogLevelCriticalOnly;
}

@end
