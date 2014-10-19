//
//  UIImageView+RUDiskImageFetching.m
//  VibeWithIt
//
//  Created by Benjamin Maer on 10/15/14.
//  Copyright (c) 2014 VibeWithIt. All rights reserved.
//

#import "UIImageView+RUDiskImageFetching.h"
#import "RUSynthesizeAssociatedObjects.h"
#import "RUDiskImageFetchingController.h"
#import "RUConditionalReturn.h"





NSString* const kRUDiskImageFetching_UIImageView_AssociatedObject_Key_Ru_fetchImageFromDiskOperation = @"kRUDiskImageFetching_UIImageView_AssociatedObject_Key_Ru_fetchImageFromDiskOperation";





@interface UIImageView (_RUDiskImageFetching)

@property (nonatomic, strong) NSOperation* ru_fetchImageFromDiskOperation;

@end





@implementation UIImageView (_RUDiskImageFetching)

#pragma mark - Synthesize Associated Objects
RU_Synthesize_AssociatedObject_GetterSetter_Implementation(ru_, Ru_, fetchImageFromDiskOperation, NSOperation*, &kRUDiskImageFetching_UIImageView_AssociatedObject_Key_Ru_fetchImageFromDiskOperation, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

@end





@implementation UIImageView (RUDiskImageFetching)

#pragma mark - Fetching
-(void)ru_fetchImageFromDiskAtFilePath:(NSString*)filePath
{
	[self ru_fetchImageFromDiskAtFilePath:filePath placeholderImage:nil];
}

-(void)ru_fetchImageFromDiskAtFilePath:(NSString *)filePath placeholderImage:(UIImage *)placeholderImage
{
	[self ru_cancelFetchImageFromDisk];

	[self setImage:placeholderImage];

	__weak __typeof(&*self)weakSelf = self;

	[self setRu_fetchImageFromDiskOperation:[[RUDiskImageFetchingController sharedInstance]fetchImageFromDiskWithPath:filePath completion:^(UIImage *image, RUDiskImageFetchingController_FetchedSourceType fetchedSourceType) {

		kRUConditionalReturn([NSThread isMainThread] == false, YES);
		kRUConditionalReturn(weakSelf == nil, NO);

		__strong __typeof(&*weakSelf)strongSelf = weakSelf;
		[strongSelf setImage:image];

	}]];
}

-(void)ru_cancelFetchImageFromDisk
{
	if (self.ru_fetchImageFromDiskOperation)
	{
		[self.ru_fetchImageFromDiskOperation cancel];
		[self setRu_fetchImageFromDiskOperation:nil];
	}
}

@end
