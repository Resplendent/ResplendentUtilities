//
//  UIImageView+RUDiskImageFetching.h
//  VibeWithIt
//
//  Created by Benjamin Maer on 10/15/14.
//  Copyright (c) 2014 VibeWithIt. All rights reserved.
//

#import <UIKit/UIKit.h>





@interface UIImageView (RUDiskImageFetching)

-(void)ru_fetchImageFromDiskAtFilePath:(NSString*)filePath;
-(void)ru_fetchImageFromDiskAtFilePath:(NSString*)filePath placeholderImage:(UIImage*)placeholderImage;

-(void)ru_cancelFetchImageFromDisk;

@end
