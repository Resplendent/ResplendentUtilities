//
//  UIButton+RUAsynchronousImageFetching.h
//  Resplendent
//
//  Created by Benjamin Maer on 4/23/13.
//  Copyright (c) 2013 Resplendent G.P. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (RUAsynchronousImageFetching)

@property (nonatomic, assign) BOOL loadsUsingSpinner;

-(void)ruCancelAsynchronousImageFetching;
-(void)ruFetchImageAsynchronouslyAtUrl:(NSURL*)url forState:(UIControlState)state;
-(void)ruFetchBackgroundImageAsynchronouslyAtUrl:(NSURL*)url forState:(UIControlState)state;

@end
