//
//  SPAdMobInterstitialAdapter.m
//  SponsorPayTestApp
//
//  Created by Daniel Barden on 01/04/14.
//  Copyright (c) 2014 SponsorPay. All rights reserved.
//

#import "SPAdMobInterstitialAdapter.h"
#import "SPAdMobNetwork.h"
#import "GADInterstitial.h"
#import "GADInterstitialDelegate.h"

#import "SPLogger.h"

static NSString *const SPAdMobAdUnitId = @"SPAdMobInterstitialAdUnitId";

@interface SPAdMobInterstitialAdapter() <GADInterstitialDelegate>

@property (weak, nonatomic) id<SPInterstitialNetworkAdapterDelegate> delegate;
@property (copy, nonatomic) NSString *adUnitId;

@property (strong, nonatomic) GADInterstitial *interstitial;

@property (assign, nonatomic) BOOL *isInterstitialAvailable;
@property (assign, nonatomic) BOOL *userClickedOnAd;

@end

@implementation SPAdMobInterstitialAdapter

@synthesize offerData;

- (BOOL)startAdapterWithDict:(NSDictionary *)dict
{
    NSString *unitId = dict[SPAdMobAdUnitId];
    if (!unitId.length) {
        SPLogError(@"Could not start %@ interstitial Adapter. %@ empty or missing.", self.networkName, SPAdMobAdUnitId);
        return NO;
    }

    self.adUnitId = unitId;
    [self fetchInterstitial];
    return YES;
}

- (NSString *)networkName
{
    return self.network.name;
}

- (BOOL)canShowInterstitial
{
    if (!self.isInterstitialAvailable) {
        [self fetchInterstitial];
    }

    return self.isInterstitialAvailable;
}

- (void)showInterstitialFromViewController:(UIViewController *)viewController
{
    [self.interstitial presentFromRootViewController:viewController];
}

- (void)fetchInterstitial
{
    GADRequest *request = [GADRequest request];
    [self configureRequestForCoppa:request];
    request.testDevices = self.network.testDevices;
    self.interstitial = [[GADInterstitial alloc] init];
    self.interstitial.adUnitID = self.adUnitId;
    self.interstitial.delegate = self;
    [self.interstitial loadRequest:request];
}

- (void)configureRequestForCoppa:(GADRequest *)request
{
    switch (self.network.coppaComplicanceStatus) {
        case SPAdmobCoppaComplianceEnabled:
            [request tagForChildDirectedTreatment:YES];
            break;
        case SPAdmobCoppaComplianceDisabled:
            [request tagForChildDirectedTreatment:NO];
        default:
            break;
    }
}

#pragma mark - GADinterstitial Delegate
- (void)interstitialDidReceiveAd:(GADInterstitial *)ad
{
    SPLogInfo(@"%@ - Interstitial Received", self.networkName);
    self.isInterstitialAvailable = YES;
}

- (void)interstitial:(GADInterstitial *)ad didFailToReceiveAdWithError:(GADRequestError *)error
{
    NSString *message = [NSString stringWithFormat:@"%@ - Interstitial failed with error: Code %d Message %@", [self networkName], error.code, [error localizedDescription]];

    self.isInterstitialAvailable = NO;

    if (error.code == kGADErrorNoFill) {
        SPLogWarn(@"%@", message);
    } else {
        SPLogError(@"%@", message);
        [self.delegate adapter:self didFailWithError:error];
    }
}

- (void)interstitialWillPresentScreen:(GADInterstitial *)ad
{
    SPLogDebug(@"%@ - Interstitial Will be presented", [self networkName]);
    self.userClickedOnAd = NO;
    [self.delegate adapterDidShowInterstitial:self];
}

- (void)interstitialWillDismissScreen:(GADInterstitial *)ad
{
    SPLogDebug(@"%@ - Interstitial Will be dismissed", [self networkName]);
    self.isInterstitialAvailable = NO;
}

- (void)interstitialDidDismissScreen:(GADInterstitial *)ad
{
    SPLogDebug(@"%@ - Interstitial did dismiss", [self networkName]);
    SPInterstitialDismissReason reason = self.userClickedOnAd ? SPInterstitialDismissReasonUserClickedOnAd : SPInterstitialDismissReasonUserClosedAd;
    [self.delegate adapter:self didDismissInterstitialWithReason:reason];
    [self fetchInterstitial];
}

- (void)interstitialWillLeaveApplication:(GADInterstitial *)ad
{
    SPLogDebug(@"%@ - Interstitial will leave application", [self networkName]);
    self.userClickedOnAd = YES;
}

@end
