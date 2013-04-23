//
//  UIButton+RUAsynchronousImageFetching.h
//  Albumatic
//
//  Created by Benjamin Maer on 4/23/13.
//  Copyright (c) 2013 Resplendent G.P. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (RUAsynchronousImageFetching)

-(void)fetchImageAtUrl:(NSURL*)url forState:(UIControlState)state;
-(void)fetchBackgroundImageAtUrl:(NSURL*)url forState:(UIControlState)state;

@end
