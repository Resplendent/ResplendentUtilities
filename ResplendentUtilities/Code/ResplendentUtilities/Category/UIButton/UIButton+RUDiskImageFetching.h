//
//  UIButton+RUDiskImageFetching.h
//  VibeWithIt
//
//  Created by Benjamin Maer on 11/17/14.
//  Copyright (c) 2014 VibeWithIt. All rights reserved.
//

#import <UIKit/UIKit.h>





@interface UIButton (RUDiskImageFetching)

-(void)ru_setImageFromDiskAtFilePath:(NSString *)filePath forState:(UIControlState)state;
-(void)ru_setImageFromDiskAtFilePath:(NSString *)filePath placeholderImage:(UIImage *)placeholderImage forState:(UIControlState)state;
-(void)ru_cancelSetImageFromDisk;

-(void)ru_setBackgroundImageFromDiskAtFilePath:(NSString *)filePath forState:(UIControlState)state;
-(void)ru_setBackgroundImageFromDiskAtFilePath:(NSString *)filePath placeholderImage:(UIImage *)placeholderImage forState:(UIControlState)state;
-(void)ru_cancelSetBackgroundImageFromDisk;

@end
