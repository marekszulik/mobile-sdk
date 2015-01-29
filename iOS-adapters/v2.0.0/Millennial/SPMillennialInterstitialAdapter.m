//
//  SPMillenialInterstitialAdapter.m
//
//  Created on 18/02/14.
//  Copyright (c) 2014 Fyber. All rights reserved.
//

#import "SPLogger.h"
#import "SPMillennialInterstitialAdapter.h"
#import "SPMillennialNetwork.h"
#import <MillennialMedia/MMRequest.h>
#import <MillennialMedia/MMInterstitial.h>
#import "SponsorPaySDK.h"
#import <CoreLocation/CoreLocation.h>
@interface SPMillennialInterstitialAdapter ()

@property (nonatomic, weak) id<SPInterstitialNetworkAdapterDelegate> delegate;
@property (nonatomic, assign) BOOL adWasTapped;

@end

@implementation SPMillennialInterstitialAdapter

@synthesize offerData;

- (BOOL)startAdapterWithDict:(NSDictionary *)dict
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(adWasTapped:)
                                                 name:MillennialMediaAdWasTapped
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(adModalDidAppear:)
                                                 name:MillennialMediaAdModalDidAppear
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(adModalDidDismiss:)
                                                 name:MillennialMediaAdModalDidDismiss
                                               object:nil];
    [self fetchOffer];
    return YES;
}

- (NSString *)networkName
{
    return [self.network name];
}

- (BOOL)canShowInterstitial
{
    if ([MMInterstitial isAdAvailableForApid:self.network.apid]) {
        return YES;
    } else {
        [self fetchOffer];
        return NO;
    }
}

- (void)showInterstitialFromViewController:(UIViewController *)viewController
{
    if (![MMInterstitial isAdAvailableForApid:self.network.apid]) {
        [self.delegate adapter:self didFailWithError:[NSError errorWithDomain:@"SPInterstitialDomain" code:-8 userInfo:@{NSLocalizedDescriptionKey: @"No interstitial available"}]];
        return;
    }
    
    [MMInterstitial displayForApid:self.network.apid
                fromViewController:viewController
                   withOrientation:MMOverlayOrientationTypeAll
                      onCompletion:^(BOOL success, NSError *error) {
                          [self fetchOffer];
                          if (error) {
                              [self.delegate adapter:self didFailWithError:error];
                          }
                      }];

}

#pragma mark - Private Methods
- (void)fetchOffer
{
    if ([MMInterstitial isAdAvailableForApid:self.network.apid]) {
        return;
    }
    
    MMRequest *request = [MMRequest request];
    
    Class SPUserClass = NSClassFromString(@"SPUser");
    SponsorPaySDK *sponsorPaySDK = [SponsorPaySDK instance];
    if (SPUserClass && [sponsorPaySDK respondsToSelector:NSSelectorFromString(@"user")]) {
        id user = [[SponsorPaySDK instance] performSelector:@selector(user)];
        if ([user respondsToSelector:NSSelectorFromString(@"location")]) {
            request.location = [user valueForKey:@"location"];
        }
    }
    
    [MMInterstitial fetchWithRequest:request apid:self.network.apid onCompletion:^(BOOL success, NSError *error) {
        if (error) {
            [self.delegate adapter:self didFailWithError:error];
        }
    }];
    
}

#pragma mark - Notifications
- (void)adWasTapped:(NSNotification *)notification
{
    SPLogDebug(@"Millennial ad was tapped");
    self.adWasTapped = YES;
}

- (void)adModalDidAppear:(NSNotification *)notification
{
    SPLogDebug(@"Millennial Ad Did appear");
    self.adWasTapped = NO;
    [self.delegate adapterDidShowInterstitial:self];
}

- (void)adModalDidDismiss:(NSNotification *)notification
{
    SPLogDebug(@"Millennial Ad Did dismiss");
    [self.delegate adapter:self didDismissInterstitialWithReason:(self.adWasTapped ? SPInterstitialDismissReasonUserClickedOnAd : SPInterstitialDismissReasonUserClosedAd)];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
