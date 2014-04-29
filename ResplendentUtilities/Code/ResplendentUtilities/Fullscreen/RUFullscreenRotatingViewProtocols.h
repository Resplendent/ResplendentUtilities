//
//  RUFullscreenRotatingViewProtocols.h
//  Resplendent
//
//  Created by Benjamin Maer on 9/12/13.
//  Copyright (c) 2013 Resplendent G.P.. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RUFullscreenRotatingView;

@protocol RUFullscreenRotatingViewHideDelegate <NSObject>

-(void)fullscreenRotatingView:(RUFullscreenRotatingView*)fullscreenRotatingView willHide:(BOOL)animated;
-(void)fullscreenRotatingView:(RUFullscreenRotatingView*)fullscreenRotatingView didHide:(BOOL)animated;

@end
