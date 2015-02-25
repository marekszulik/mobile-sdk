//
// SPVungleNetwork.h
//
// Created on 13/01/14.
// Copyright (c) 2014 Fyber. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <VungleSDK/VungleSDK.h>
#import "SPBaseNetwork.h"

/**
 Network class in charge of integrating Vungle library
 
 ## Version compatibility
 
 - Adapter version: 2.4.0
 
 */

@interface SPVungleNetwork : SPBaseNetwork

@property (nonatomic, copy) NSString *appId;
@property (nonatomic, copy) NSString *orientation;
@property (nonatomic, readonly) UIInterfaceOrientationMask orientationMask;
@property (nonatomic, copy) NSNumber *incentivized;
@property (nonatomic, copy) NSString *incentivizedAlertTitleText;
@property (nonatomic, copy) NSString *incentivizedAlertBodyText;
@property (nonatomic, copy) NSString *incentivizedAlertCloseButtonText;
@property (nonatomic, copy) NSString *incentivizedAlertContinueButtonText;

@end
