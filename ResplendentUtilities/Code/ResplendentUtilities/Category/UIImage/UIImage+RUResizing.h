//
//  UIImage+Resizing.h
//  Resplendent
//
//  Created by Sheldon on 10/2/12.
//
//

#import <UIKit/UIKit.h>




typedef NS_ENUM(NSInteger, UIImage_RUResizing_ResizeMode) {
	UIImage_RUResizing_ResizeMode_ScaleToFill,
	UIImage_RUResizing_ResizeMode_AspectFit,
	UIImage_RUResizing_ResizeMode_AspectFill,
};





@interface UIImage (RUResizing)

-(UIImage*)ru_scaleToSize:(CGSize)newSize usingMode:(UIImage_RUResizing_ResizeMode)resizeMode;

-(UIImage*)ru_scaleToFitSize:(CGSize)newSize;		//UIImage_RUResizing_ResizeMode_AspectFit
-(UIImage*)ru_scaleToFillSize:(CGSize)newSize;		//UIImage_RUResizing_ResizeMode_ScaleToFill
-(UIImage*)ru_scaleToCoverSize:(CGSize)newSize;		//UIImage_RUResizing_ResizeMode_AspectFill

-(BOOL)ru_imageHasAlpha;
+(BOOL)ru_imageHasAlpha:(CGImageRef)imageRef;

+(CGContextRef)ru_createARGBBitmapContext:(const size_t)width height:(const size_t)height bytesPerRow:(const size_t)bytesPerRow withAlpha:(BOOL)withAlpha;

@end
