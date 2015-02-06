//
//  SPFlurryInterstitialAdapter.m
//
//  Copyright (c) 2014 Fyber. All rights reserved.
//

#import "SPFlurryInterstitialAdapter.h"
#import "SPFlurryNetwork.h"
#import "SPLogger.h"
#import "SPInterstitialClient.h"

static NSString *const SPFlurryInterstitialAdSpace = @"SPFlurryAdSpaceInterstitial";

@interface SPFlurryAppCircleClipsInterstitialAdapter ()

@property (nonatomic, weak) id<SPInterstitialNetworkAdapterDelegate> delegate;
@property (nonatomic, copy) NSString *interstitialAdsSpace;
@property (strong) FlurryAdInterstitial *adInterstitial;
@property (nonatomic, assign) BOOL isFetchingAd;
@property (nonatomic, assign) BOOL wasAdClicked;

@end

@implementation SPFlurryAppCircleClipsInterstitialAdapter

@synthesize offerData;

- (NSString *)networkName
{
    return [self.network name];
}

- (BOOL)startAdapterWithDict:(NSDictionary *)dict
{
    self.interstitialAdsSpace = dict[SPFlurryInterstitialAdSpace];
    if (!self.interstitialAdsSpace) {
        SPLogError(@"Could not start %@ interstitial Adapter. %@ empty or missing.", self.networkName, SPFlurryInterstitialAdSpace);
        return NO;
    }

    [self fetchFlurryAd];
    return YES;
}

- (void)fetchFlurryAd
{
    self.isFetchingAd = YES;
    self.adInterstitial = [[FlurryAdInterstitial alloc] initWithSpace:self.interstitialAdsSpace];
    self.adInterstitial.adDelegate = self;
    [self.adInterstitial fetchAd];
}


#pragma mark - SPInterstitialNetworkAdapter protocol

- (BOOL)canShowInterstitial
{
    if (!self.adInterstitial.ready && !self.isFetchingAd) {
        [self fetchFlurryAd];
    }
    return self.adInterstitial.ready;
}

- (void)showInterstitialFromViewController:(UIViewController *)viewController
{
    if (self.adInterstitial.ready) {
        self.wasAdClicked = NO;
        [self.adInterstitial presentWithViewControler:viewController];
    } else {
        NSString *description = [NSString stringWithFormat:@"Interstitial for network %@ is not available", self.network.name];
        SPLogError(@"%@", description);
        NSError *error = [NSError errorWithDomain:SPInterstitialClientErrorDomain
                                             code:SPInterstitialClientCannotInstantiateAdapterErrorCode
                                         userInfo:@{ SPInterstitialClientErrorLoggableDescriptionKey: description }];
        [self.delegate adapter:self didFailWithError:error];
    }
}


- (void)adInterstitialDidFetchAd:(FlurryAdInterstitial *)adInterstitial
{
    self.isFetchingAd = NO;
}

- (void)adInterstitialDidRender:(FlurryAdInterstitial *)interstitialAd
{
    [self.delegate adapterDidShowInterstitial:self];
}

- (void)adInterstitialDidDismiss:(FlurryAdInterstitial *)interstitialAd
{
    SPInterstitialDismissReason dismissReason =
    self.wasAdClicked ? SPInterstitialDismissReasonUserClickedOnAd : SPInterstitialDismissReasonUserClosedAd;
    [self.delegate adapter:self didDismissInterstitialWithReason:dismissReason];
    
    [self fetchFlurryAd];
}

- (void)adInterstitialDidReceiveClick:(FlurryAdInterstitial *)interstitialAd
{
    self.wasAdClicked = YES;
}

- (void)adInterstitial:(FlurryAdInterstitial *)interstitialAd
               adError:(FlurryAdError)adError
      errorDescription:(NSError *)errorDescription
{
    self.isFetchingAd = NO;
    if (adError == FLURRY_AD_ERROR_DID_FAIL_TO_FETCH_AD) {
        SPLogError(@"Flurry failed to fetch interstitial");
    } else {
        NSError *interstitialError =
        [NSError errorWithDomain:@"com.sponsorpay.interstitialError"
                            code:errorDescription.code
                        userInfo:@{NSLocalizedDescriptionKey: [NSString stringWithFormat:@"Flurry error: %@", errorDescription.localizedDescription]}];
        [self.delegate adapter:self didFailWithError:interstitialError];
    }
}


@end
