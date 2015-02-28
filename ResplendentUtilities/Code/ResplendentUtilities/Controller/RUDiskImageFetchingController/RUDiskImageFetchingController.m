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





#define kRUDiskImageFetchingController__UseFileManager 1





@interface RUDiskImageFetchingController ()

#if kRUDiskImageFetchingController__UseFileManager
@property (nonatomic, readonly) NSFileManager* fileManager;
#endif

@property (nonatomic, readonly) NSCache* memCache;
-(void)addImageToCache:(UIImage*)image withKey:(NSString*)key;
-(void)removeImageFromCacheWithKey:(NSString*)key;

-(UIImage *)imageFromCacheForKey:(NSString *)key;
-(void)clearCache;

-(NSString*)keyForPath:(NSString*)path;

@property (nonatomic, strong) dispatch_queue_t queue;

-(void)notificationDidFire_UIApplication_DidReceiveMemoryWarningNotification;

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

#if kRUDiskImageFetchingController__UseFileManager
		dispatch_sync(self.queue, ^{
			_fileManager = [NSFileManager new];
		});
#endif

		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(notificationDidFire_UIApplication_DidReceiveMemoryWarningNotification)
													 name:UIApplicationDidReceiveMemoryWarningNotification
												   object:nil];
	}

	return self;
}

#pragma mark - Fetching
-(NSOperation*)fetchImageFromDiskWithPath:(NSString*)path completion:(RUDiskImageFetchingController_QueryCompletedBlock)completion
{
	kRUConditionalReturn_ReturnValueNil(path.length == 0, NO);

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
#if kRUDiskImageFetchingController__UseFileManager
				BOOL isDirectory = false;
				if ([self.fileManager fileExistsAtPath:path isDirectory:&isDirectory])
				{
					if (isDirectory)
					{
						NSAssert(false, @"unhandled");
					}
					else
					{
						NSData* diskImageData = [self.fileManager contentsAtPath:path];
						
						if (diskImageData.length)
						{
							diskImage = [UIImage imageWithData:diskImageData];
							[self addImageToCache:diskImage withKey:key];
							
							fetchedSourceType = RUDiskImageFetchingController_FetchedSourceType_Cache;
						}
					}
				}
#else
				NSError* fetchFromDiskError = nil;
				NSData* diskImageData = [NSData dataWithContentsOfFile:path options:0 error:&fetchFromDiskError];
				
				if ((fetchFromDiskError == nil) && diskImageData.length)
				{
					diskImage = [UIImage imageWithData:diskImageData];
					[self addImageToCache:diskImage withKey:key];
					
					fetchedSourceType = RUDiskImageFetchingController_FetchedSourceType_Cache;
				}
#endif

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

-(void)removeImageFromCacheWithKey:(NSString*)key
{
	[self.memCache removeObjectForKey:key];
}

-(void)removeImageFromCacheAtFilePath:(NSString*)filePath
{
	kRUConditionalReturn(filePath.length == 0, YES);

	NSString* key = [self keyForPath:filePath];
	kRUConditionalReturn(key.length == 0, YES);

	[self removeImageFromCacheWithKey:key];
}

-(UIImage *)imageFromCacheForKey:(NSString *)key
{
	return [self.memCache objectForKey:key];
}

-(void)clearCache
{
	[self.memCache removeAllObjects];
}

#pragma mark - Key
-(NSString*)keyForPath:(NSString*)path
{
	return [path copy];
}

#pragma mark - Singleton
RUSingletonUtil_Synthesize_Singleton_Implementation_SharedInstance

#pragma mark - Notifications
-(void)notificationDidFire_UIApplication_DidReceiveMemoryWarningNotification
{
	[self clearCache];
}

@end
