//
//  UIImage+RUSaveToAssetsLibrary.m
//  Camerama
//
//  Created by Benjamin Maer on 12/1/14.
//  Copyright (c) 2014 Camerama. All rights reserved.
//

#import "UIImage+RUSaveToAssetsLibrary.h"





@implementation UIImage (RUSaveToAssetsLibrary)

-(void)ru_saveToAssetsLibraryWithMetadata:(NSDictionary *)metadata completionBlock:(ALAssetsLibraryWriteImageCompletionBlock)completionBlock
{
	[self.class ru_saveImageRefToAssetsLibrary:self.CGImage metadata:metadata completionBlock:completionBlock];
}

+(void)ru_saveImageRefToAssetsLibrary:(CGImageRef)imageRef metadata:(NSDictionary *)metadata completionBlock:(ALAssetsLibraryWriteImageCompletionBlock)completionBlock
{
	static ALAssetsLibrary* assetsLibrary = nil;

	dispatch_async(dispatch_get_main_queue(), ^{

		static dispatch_once_t onceToken;
		dispatch_once(&onceToken, ^{
			assetsLibrary = [ALAssetsLibrary new];
		});

		[assetsLibrary writeImageToSavedPhotosAlbum:imageRef metadata:metadata completionBlock:completionBlock];

	});
}

@end
