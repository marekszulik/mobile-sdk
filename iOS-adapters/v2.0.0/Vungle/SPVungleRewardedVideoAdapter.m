//
// SPVungleAdapter.m
//
// Created on 5/30/13.
// Copyright 2011-2013 Fyber. All rights reserved.
//

#import "SPVungleRewardedVideoAdapter.h"
#import "SPVungleNetwork.h"
#import "SPLogger.h"

#ifndef LogInvocation
#define LogInvocation SPLogDebug(@"%s", __PRETTY_FUNCTION__)
#endif

@interface SPVungleRewardedVideoAdapter ()
@property (assign) BOOL videoDidPlayFull;
@end

@implementation SPVungleRewardedVideoAdapter

@synthesize delegate;

- (NSString *)networkName
{
    return self.network.name;
}

- (BOOL)startAdapterWithDictionary:(NSDictionary *)dict
{
    return YES;
}

- (void)checkAvailability
{
    [self.delegate adapter:self didReportVideoAvailable:[[VungleSDK sharedSDK] isCachedAdAvailable]];
}

- (void)playVideoWithParentViewController:(UIViewController *)parentVC
{
    self.videoDidPlayFull = NO;
    [[VungleSDK sharedSDK] setDelegate:self];

    // additional configuration
    NSMutableDictionary *options = [NSMutableDictionary dictionary];
    if (self.network.orientation.length) {
        [options setObject:@(self.network.orientationMask) forKey:VunglePlayAdOptionKeyOrientations];
    }
    if (self.network.incentivized) {
        [options setObject:self.network.incentivized forKey:VunglePlayAdOptionKeyIncentivized];
    }
    if (self.network.incentivizedAlertTitleText) {
        [options setObject:self.network.incentivizedAlertTitleText forKey:VunglePlayAdOptionKeyIncentivizedAlertTitleText];
    }
    if (self.network.incentivizedAlertBodyText) {
        [options setObject:self.network.incentivizedAlertBodyText forKey:VunglePlayAdOptionKeyIncentivizedAlertBodyText];
    }
    if (self.network.incentivizedAlertCloseButtonText) {
        [options setObject:self.network.incentivizedAlertCloseButtonText forKey:VunglePlayAdOptionKeyIncentivizedAlertCloseButtonText];
    }
    if (self.network.incentivizedAlertContinueButtonText) {
        [options setObject:self.network.incentivizedAlertContinueButtonText forKey:VunglePlayAdOptionKeyIncentivizedAlertContinueButtonText];
    }

    NSError *error = nil;
    [[VungleSDK sharedSDK] playAd:parentVC withOptions:options error:&error];

    if (error) {
        SPLogError(@"Vungle error %d: %@", [error code], [error localizedDescription]);
    }
}

#pragma mark - VGVunglePubDelegate protocol implementation

// Called immeddiately before Vungle's ad view controller appears.
// It's the closest we have to the video started event
- (void)vungleSDKwillShowAd
{
    LogInvocation;

    [self.delegate adapterVideoDidStart:self];
}

- (void)vungleSDKwillCloseAdWithViewInfo:(NSDictionary *)viewInfo willPresentProductSheet:(BOOL)willPresentProductSheet
{
    LogInvocation;

    self.videoDidPlayFull = [viewInfo[@"completedView"] boolValue];

    if (self.videoDidPlayFull) {
        [self.delegate adapterVideoDidFinish:self];
    }

    if (!willPresentProductSheet) {
        [self reportAdDidClose];
    }
}

- (void)vungleSDKwillCloseProductSheet:(id)productSheet
{
    LogInvocation;
    [self reportAdDidClose];
}

- (void)reportAdDidClose
{
    if (self.videoDidPlayFull) {
        [self.delegate adapterVideoDidClose:self];
    } else {
        [self.delegate adapterVideoDidAbort:self];
    }
}

@end
