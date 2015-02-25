//
// SPVungleNetwork.m
//
// Created on 13/01/14.
// Copyright (c) 2014 Fyber. All rights reserved.
//

#import "SPVungleNetwork.h"
#import "SPLogger.h"
#import "SPSemanticVersion.h"
#import "SPTPNGenericAdapter.h"

static NSString *const SPVungleAppId = @"SPVungleAppId";
static NSString *const SPVungleOrientation = @"SPVungleOrientation";
static NSString *const SPVungleIncentivized = @"SPVungleIncentivized";
static NSString *const SPVungleIncentivizedAlertTitleText = @"SPVungleIncentivizedAlertTitleText";
static NSString *const SPVungleIncentivizedAlertBodyText = @"SPVungleIncentivizedAlertBodyText";
static NSString *const SPVungleIncentivizedAlertCloseButtonText = @"SPVungleIncentivizedAlertCloseButtonText";
static NSString *const SPVungleIncentivizedAlertContinueButtonText = @"SPVungleIncentivizedAlertContinueButtonText";

static const NSInteger SPVungleVersionMajor = 2;
static const NSInteger SPVungleVersionMinor = 4;
static const NSInteger SPVungleVersionPatch = 0;

static NSString *const SPRewardedVideoAdapterClassName = @"SPVungleRewardedVideoAdapter";

// Screen orientation Constatns
NSString *const SPVungleInterfaceOrientationMaskPortrait = @"portrait";
NSString *const SPVungleInterfaceOrientationMaskLandscapeLeft = @"landscapeLeft";
NSString *const SPVungleInterfaceOrientationMaskLandscapeRight = @"landscapeRight";
NSString *const SPVungleInterfaceOrientationMaskPortraitUpsideDown = @"portraitUpsideDown";
NSString *const SPVungleInterfaceOrientationMaskLandscape = @"landscape";
NSString *const SPVungleInterfaceOrientationMaskAll = @"all";
NSString *const SPVungleInterfaceOrientationMaskAllButUpsideDown = @"allButUpsideDown";

@interface SPVungleNetwork ()

@property (nonatomic, assign) SPNetworkSupport supportedServices;
@property (nonatomic, copy) NSString *providerName;
@property (nonatomic, strong) SPTPNGenericAdapter *rewardedVideoAdapter;
@end

@implementation SPVungleNetwork

@synthesize supportedServices;
@synthesize rewardedVideoAdapter = _rewardedVideoAdapter;

#pragma mark - Class Methods

+ (SPSemanticVersion *)adapterVersion
{
    return [SPSemanticVersion versionWithMajor:SPVungleVersionMajor minor:SPVungleVersionMinor patch:SPVungleVersionPatch];
}

#pragma mark - Initialization

- (BOOL)startSDK:(NSDictionary *)data
{
    NSString *appId = data[SPVungleAppId];

    if (!appId.length) {
        SPLogError(@"Could not start %@ Provider. %@ empty or missing.", self.name, SPVungleAppId);
        return NO;
    }

    self.orientation = data[SPVungleOrientation];
    self.incentivized = data[SPVungleIncentivized];
    self.incentivizedAlertTitleText = data[SPVungleIncentivizedAlertTitleText];
    self.incentivizedAlertBodyText = data[SPVungleIncentivizedAlertBodyText];
    self.incentivizedAlertCloseButtonText = data[SPVungleIncentivizedAlertCloseButtonText];
    self.incentivizedAlertContinueButtonText = data[SPVungleIncentivizedAlertContinueButtonText];

    self.appId = appId;
    [[VungleSDK sharedSDK] startWithAppId:self.appId];
    return YES;
}

- (void)startRewardedVideoAdapter:(NSDictionary *)data
{
    Class RewardedVideoAdapterClass = NSClassFromString(SPRewardedVideoAdapterClassName);
    if (!RewardedVideoAdapterClass) {
        return;
    }

    id<SPRewardedVideoNetworkAdapter> vungleRewardedVideoAdapter = [[RewardedVideoAdapterClass alloc] init];

    SPTPNGenericAdapter *vungleRewardedVideoAdapterWrapper = [[SPTPNGenericAdapter alloc] initWithVideoNetworkAdapter:vungleRewardedVideoAdapter];
    vungleRewardedVideoAdapter.delegate = vungleRewardedVideoAdapterWrapper;

    self.rewardedVideoAdapter = vungleRewardedVideoAdapterWrapper;

    [super startRewardedVideoAdapter:data];
}

#pragma mark - Helper methods

- (UIInterfaceOrientationMask)orientationMask
{
    if ([self.orientation isEqualToString:SPVungleInterfaceOrientationMaskPortrait])
        return UIInterfaceOrientationMaskPortrait;
    if ([self.orientation isEqualToString:SPVungleInterfaceOrientationMaskLandscapeLeft])
        return UIInterfaceOrientationMaskLandscapeLeft;
    if ([self.orientation isEqualToString:SPVungleInterfaceOrientationMaskLandscapeRight])
        return UIInterfaceOrientationMaskLandscapeRight;
    if ([self.orientation isEqualToString:SPVungleInterfaceOrientationMaskPortraitUpsideDown])
        return UIInterfaceOrientationMaskPortraitUpsideDown;
    if ([self.orientation isEqualToString:SPVungleInterfaceOrientationMaskLandscape])
        return UIInterfaceOrientationMaskLandscape;
    if ([self.orientation isEqualToString:SPVungleInterfaceOrientationMaskAll])
        return UIInterfaceOrientationMaskAll;
    if ([self.orientation isEqualToString:SPVungleInterfaceOrientationMaskAllButUpsideDown])
        return UIInterfaceOrientationMaskAllButUpsideDown;
    return UIInterfaceOrientationMaskAll;
}

@end
