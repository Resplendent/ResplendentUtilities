//
//  UIImage+RUImageFromColor.h
//  Nifti
//
//  Created by Benjamin Maer on 1/3/15.
//  Copyright (c) 2015 Nifti. All rights reserved.
//

#import <UIKit/UIKit.h>





@interface UIImage (RUImageFromColor)

+(UIImage*)ru_imageFromColor:(UIColor *)color forSize:(CGSize)size withCornerRadius:(CGFloat)radius;
//+(UIImage*)ru_imageFromColor:(UIColor *)color forSize:(CGSize)size;

@end
