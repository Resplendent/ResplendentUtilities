//
//  UIButton+RUDiskImageFetching.m
//  VibeWithIt
//
//  Created by Benjamin Maer on 11/17/14.
//  Copyright (c) 2014 VibeWithIt. All rights reserved.
//

#import "UIButton+RUDiskImageFetching.h"
#import "RUSynthesizeAssociatedObjects.h"
#import "RUDiskImageFetchingController.h"
#import "RUConditionalReturn.h"





NSString* const kRUDiskImageFetching_UIButton_AssociatedObject_Key_Ru_fetchImageFromDiskOperation = @"kRUDiskImageFetching_UIButton_AssociatedObject_Key_Ru_fetchImageFromDiskOperation";
NSString* const kRUDiskImageFetching_UIButton_AssociatedObject_Key_Ru_fetchBackgroundImageFromDiskOperation = @"kRUDiskImageFetching_UIButton_AssociatedObject_Key_Ru_fetchBackgroundImageFromDiskOperation";





@interface UIButton (_RUDiskImageFetching)

@property (nonatomic, strong) NSOperation* ru_fetchImageFromDiskOperation;
@property (nonatomic, strong) NSOperation* ru_fetchBackgroundImageFromDiskOperation;

@end





@implementation UIButton (_RUDiskImageFetching)

#pragma mark - Synthesize Associated Objects
RU_Synthesize_AssociatedObject_GetterSetter_Implementation(ru_, Ru_, fetchImageFromDiskOperation, NSOperation*, &kRUDiskImageFetching_UIButton_AssociatedObject_Key_Ru_fetchImageFromDiskOperation, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
RU_Synthesize_AssociatedObject_GetterSetter_Implementation(ru_, Ru_, fetchBackgroundImageFromDiskOperation, NSOperation*, &kRUDiskImageFetching_UIButton_AssociatedObject_Key_Ru_fetchBackgroundImageFromDiskOperation, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

@end





@implementation UIButton (RUDiskImageFetching)

#pragma mark - Image Fetching
-(void)ru_setImageFromDiskAtFilePath:(NSString *)filePath forState:(UIControlState)state
{
	[self ru_setImageFromDiskAtFilePath:filePath placeholderImage:nil forState:state];
}

-(void)ru_setImageFromDiskAtFilePath:(NSString *)filePath placeholderImage:(UIImage *)placeholderImage forState:(UIControlState)state
{
	[self ru_cancelSetImageFromDisk];
	
	[self setImage:placeholderImage forState:state];
	
	__weak __typeof(&*self)weakSelf = self;
	
	[self setRu_fetchImageFromDiskOperation:[[RUDiskImageFetchingController sharedInstance]fetchImageFromDiskWithPath:filePath completion:^(UIImage *image, RUDiskImageFetchingController_FetchedSourceType fetchedSourceType) {
		
		kRUConditionalReturn([NSThread isMainThread] == false, YES);
		kRUConditionalReturn(weakSelf == nil, NO);
		
		__strong __typeof(&*weakSelf)strongSelf = weakSelf;
		[strongSelf setImage:image forState:state];
		
	}]];
}

-(void)ru_cancelSetImageFromDisk
{
	if (self.ru_fetchImageFromDiskOperation)
	{
		[self.ru_fetchImageFromDiskOperation cancel];
		[self setRu_fetchImageFromDiskOperation:nil];
	}
}

#pragma mark - Background Image Fetching
-(void)ru_setBackgroundImageFromDiskAtFilePath:(NSString *)filePath forState:(UIControlState)state
{
	[self ru_setBackgroundImageFromDiskAtFilePath:filePath placeholderImage:nil forState:state];
}

-(void)ru_setBackgroundImageFromDiskAtFilePath:(NSString *)filePath placeholderImage:(UIImage *)placeholderImage forState:(UIControlState)state
{
	[self ru_cancelSetBackgroundImageFromDisk];
	
	[self setBackgroundImage:placeholderImage forState:state];
	
	__weak __typeof(&*self)weakSelf = self;
	
	[self setRu_fetchBackgroundImageFromDiskOperation:[[RUDiskImageFetchingController sharedInstance]fetchImageFromDiskWithPath:filePath completion:^(UIImage *image, RUDiskImageFetchingController_FetchedSourceType fetchedSourceType) {
		
		kRUConditionalReturn([NSThread isMainThread] == false, YES);
		kRUConditionalReturn(weakSelf == nil, NO);
		
		__strong __typeof(&*weakSelf)strongSelf = weakSelf;
		[strongSelf setBackgroundImage:image forState:state];
		
	}]];
}

-(void)ru_cancelSetBackgroundImageFromDisk
{
	if (self.ru_fetchBackgroundImageFromDiskOperation)
	{
		[self.ru_fetchBackgroundImageFromDiskOperation cancel];
		[self setRu_fetchBackgroundImageFromDiskOperation:nil];
	}
}

@end
