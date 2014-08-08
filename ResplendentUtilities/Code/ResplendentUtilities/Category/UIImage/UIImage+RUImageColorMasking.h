//
//  UIImage+RUImageColorMasking.h
//  Shimmur
//
//  Created by Benjamin Maer on 7/31/14.
//  Copyright (c) 2014 ShimmurInc. All rights reserved.
//

#import <UIKit/UIKit.h>





@interface UIImage (RUImageColorMasking)

-(UIImage*)ruImageByApplyingMaskWithColor:(UIColor*)color;

@end
