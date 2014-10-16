//
//  RUDiskImageFetchingController.m
//  VibeWithIt
//
//  Created by Benjamin Maer on 10/15/14.
//  Copyright (c) 2014 VibeWithIt. All rights reserved.
//

#import "RUDiskImageFetchingController.h"
#import "RUSingleton.h"
#import "RUConditionalReturn.h"





@interface RUDiskImageFetchingController ()

@property (nonatomic, readonly) NSCache* memCache;
-(void)addImageToCache:(UIImage*)image withKey:(NSString*)key;
-(UIImage *)imageFromCacheForKey:(NSString *)key;

-(NSString*)keyForPath:(NSString*)path;

@property (nonatomic, strong) dispatch_queue_t queue;

@end





@implementation RUDiskImageFetchingController

-(instancetype)init
{
	if (self = [super init])
	{
		char* const nameSpace = "com.RUDiskImageFetchingController";

		_memCache = [NSCache new];
		[self.memCache setName:[[NSString stringWithUTF8String:nameSpace] stringByAppendingString:@".memCache"]];

		_queue = dispatch_queue_create(nameSpace, DISPATCH_QUEUE_SERIAL);
	}

	return self;
}

#pragma mark - Fetching
-(NSOperation*)fetchImageFromDiskWithPath:(NSString*)path completion:(RUDiskImageFetchingController_QueryCompletedBlock)completion
{
	NSOperation *operation = [NSOperation new];

	dispatch_async(self.queue, ^{

		kRUConditionalReturn(operation.isCancelled, NO);
		
		@autoreleasepool {
			NSString* key = [self keyForPath:path];
			NSAssert(key.length > 0, @"unhandled");

			RUDiskImageFetchingController_FetchedSourceType fetchedSourceType = RUDiskImageFetchingController_FetchedSourceType_None;
			UIImage* diskImage = [self imageFromCacheForKey:key];

			if (diskImage)
			{
				fetchedSourceType = RUDiskImageFetchingController_FetchedSourceType_Cache;
			}
			else
			{
				NSError* fetchFromDiskError = nil;
				NSData* diskImageData = [NSData dataWithContentsOfFile:path options:0 error:&fetchFromDiskError];

				if (fetchFromDiskError && diskImageData.length)
				{
					diskImage = [UIImage imageWithData:diskImageData];
					[self addImageToCache:diskImage withKey:key];
					
					fetchedSourceType = RUDiskImageFetchingController_FetchedSourceType_Cache;
				}
			}
			
			dispatch_async(dispatch_get_main_queue(), ^{

				kRUConditionalReturn(operation.isCancelled, NO);

				completion(diskImage, fetchedSourceType);

			});
		}
	});

	return operation;
}

#pragma mark - Cache
-(void)addImageToCache:(UIImage *)image withKey:(NSString *)key
{
	[self.memCache setObject:image forKey:key cost:image.size.height * image.size.width * image.scale];
}

-(UIImage *)imageFromCacheForKey:(NSString *)key
{
	return [self.memCache objectForKey:key];
}

#pragma mark - Key
-(NSString*)keyForPath:(NSString*)path
{
	return [path copy];
}

#pragma mark - Singleton
RUSingletonUtil_Synthesize_Singleton_Implementation_SharedInstance

@end
