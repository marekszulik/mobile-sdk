//
//  SPFlurryRewardedVideoAdapter.m
//
//  Created on 6/17/13.
//  Copyright (c) 2011-2014 Fyber. All rights reserved.
//

#import "SPFlurryRewardedVideoAdapter.h"
#import "SPFlurryNetwork.h"
#import "SPLogger.h"
#import "FlurryAdInterstitial.h"

static NSString *const SPFlurryVideoAdSpace = @"SPFlurryAdSpaceVideo";
static NSString *const SPFlurryErrorDomain = @"SPFlurryErrorDomain";
static const NSInteger SPFlurryVideoNotReadyErrorCode = -4;

@interface SPFlurryAppCircleClipsRewardedVideoAdapter ()

@property (nonatomic, copy) NSString *videoAdsSpace;
@property (nonatomic, strong) FlurryAdInterstitial *adInterstitial;
@property (nonatomic, assign) BOOL isFetchingAd;
@property (nonatomic, assign) BOOL isVideoFullyWatched;

@end

@implementation SPFlurryAppCircleClipsRewardedVideoAdapter

@synthesize delegate;

#pragma mark - SPRewardedVideoNetworkAdapter

- (BOOL)startAdapterWithDictionary:(NSDictionary *)dict
{
    self.videoAdsSpace = dict[SPFlurryVideoAdSpace];
    if (!self.videoAdsSpace) {
        SPLogError(@"Could not start %@ video Adapter. %@ empty or missing.", self.networkName, SPFlurryVideoAdSpace);
        return NO;
    }
    
    [self fetchFlurryAd];
    return YES;
}

- (NSString *)networkName
{
    return self.network.name;
}

- (void)fetchFlurryAd
{
    self.isFetchingAd = YES;
    self.adInterstitial = [[FlurryAdInterstitial alloc] initWithSpace:self.videoAdsSpace];
    self.adInterstitial.adDelegate = self;
    [self.adInterstitial fetchAd];
}

- (void)checkAvailability
{
    BOOL isInterstitialReady = self.adInterstitial.ready;
    [self.delegate adapter:self didReportVideoAvailable:isInterstitialReady];
    if (!isInterstitialReady && !self.isFetchingAd) {
        [self fetchFlurryAd];
    }
}

- (void)playVideoWithParentViewController:(UIViewController *)parentVC
{
    if ([self.adInterstitial ready]) {
        self.isVideoFullyWatched = NO;
        [self.adInterstitial presentWithViewControler:parentVC];
    } else {
        NSString *errorDescription = @"Flurry video is not ready";
        [self.delegate adapter:self
              didFailWithError:[NSError errorWithDomain:SPFlurryErrorDomain
                                                   code:SPFlurryVideoNotReadyErrorCode
                                               userInfo:@{ NSLocalizedDescriptionKey: errorDescription }]];
    }
}

#pragma mark - FlurryAdInterstitialDelegate

- (void)adInterstitialDidFetchAd:(FlurryAdInterstitial *)interstitialAd
{
    self.isFetchingAd = NO;
}

- (void)adInterstitialDidRender:(FlurryAdInterstitial *)interstitialAd
{
    [self.delegate adapterVideoDidStart:self];
}

- (void)adInterstitialDidDismiss:(FlurryAdInterstitial *)interstitialAd
{
    if (self.isVideoFullyWatched) {
        [self.delegate adapterVideoDidClose:self];
    } else {
        [self.delegate adapterVideoDidAbort:self];
    }
    
    [self fetchFlurryAd];
}


- (void)adInterstitialVideoDidFinish:(FlurryAdInterstitial *)interstitialAd
{
    self.isVideoFullyWatched = YES;
    [self.delegate adapterVideoDidFinish:self];
}


- (void)adInterstitial:(FlurryAdInterstitial *)interstitialAd
               adError:(FlurryAdError)adError
      errorDescription:(NSError *)errorDescription
{
    self.isFetchingAd = NO;
    SPLogError(@"Flurry error:\ncode: %d\ntype: %d\ndescription: %@", errorDescription.code, adError, errorDescription.localizedDescription);
    
    switch (adError) {
    case FLURRY_AD_ERROR_DID_FAIL_TO_FETCH_AD:
        SPLogError(@"Flurry failed to fetch rewarded video");
        break;
    case FLURRY_AD_ERROR_CLICK_ACTION_FAILED:
    case FLURRY_AD_ERROR_DID_FAIL_TO_RENDER:
    default:
        {
            NSError *rvError =
            [NSError errorWithDomain:SPFlurryErrorDomain
                                code:errorDescription.code
                            userInfo:@{ NSLocalizedDescriptionKey: [NSString stringWithFormat:@"Flurry error: %@", errorDescription.localizedDescription]}];
            [self.delegate adapter:self didFailWithError:rvError];
        }
        break;
    }
}

@end
