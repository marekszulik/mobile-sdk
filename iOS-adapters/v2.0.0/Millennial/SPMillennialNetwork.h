//
//  SPMillennialNetwork.h
//
//  Created on 18/02/14.
//  Copyright (c) 2014 Fyber. All rights reserved.
//

#import "SPBaseNetwork.h"

/**
 Network class in charge of integrating Millennial Media library
 
 ## Version compatibility
 
 - Adapter version: 2.0.3
 - Fyber SDK version: 7.0.3
 - Millennial Media SDK version: 5.4.1
 
 */

@interface SPMillennialNetwork : SPBaseNetwork

@property (copy, nonatomic) NSString *apid;

@end
