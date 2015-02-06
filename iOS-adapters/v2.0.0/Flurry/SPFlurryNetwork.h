//
//  SPFlurryNetwork.h
//
//  Created on 02/01/14.
//  Copyright (c) 2014 Fyber. All rights reserved.
//

#import "SPBaseNetwork.h"


/**
 Network class in charge of integrating Flurry Ads library
 
 ## Version compatibility
 
 - Adapter version: 2.4.1
 - Fyber SDK version: 7.0.3
 - Flurry SDK version: 6.0.0
 
 */

@interface SPFlurryAppCircleClipsNetwork : SPBaseNetwork

@property (nonatomic, weak, readonly) UIWindow *mainWindow;
@end
