//
//  UIImage+RUSaveToAssetsLibrary.h
//  Camerama
//
//  Created by Benjamin Maer on 12/1/14.
//  Copyright (c) 2014 Camerama. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/ALAssetsLibrary.h>





@interface UIImage (RUSaveToAssetsLibrary)

-(void)ru_saveToAssetsLibraryWithMetadata:(NSDictionary *)metadata completionBlock:(ALAssetsLibraryWriteImageCompletionBlock)completionBlock;

+(void)ru_saveImageRefToAssetsLibrary:(CGImageRef)imageRef metadata:(NSDictionary *)metadata completionBlock:(ALAssetsLibraryWriteImageCompletionBlock)completionBlock;

@end
