//
//  RUViewStackProtocols.h
//  ResplendentUtilities
//
//  Created by Benjamin Maer on 10/5/14.
//  Copyright (c) 2014 Resplendent. All rights reserved.
//

#import <Foundation/Foundation.h>





@class RUViewStack;





@protocol RUViewStackProtocol <NSObject>


@required
@property (nonatomic, assign) RUViewStack* viewStack;

@property (nonatomic, readonly) CGSize viewSize;


@optional
@property (nonatomic, readonly) CGPoint viewOriginOffset;

@end
