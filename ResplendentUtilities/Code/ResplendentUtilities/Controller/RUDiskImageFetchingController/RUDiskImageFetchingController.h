//
//  RUDiskImageFetchingController.h
//  VibeWithIt
//
//  Created by Benjamin Maer on 10/15/14.
//  Copyright (c) 2014 VibeWithIt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>





typedef NS_ENUM(NSInteger, RUDiskImageFetchingController_FetchedSourceType) {
	RUDiskImageFetchingController_FetchedSourceType_None = 0,

	RUDiskImageFetchingController_FetchedSourceType_Disk = 100,
	RUDiskImageFetchingController_FetchedSourceType_Cache,
};





typedef void(^RUDiskImageFetchingController_QueryCompletedBlock)(UIImage *image, RUDiskImageFetchingController_FetchedSourceType fetchedSourceType);





@interface RUDiskImageFetchingController : NSObject

//If the operation is canceled before it's finished, the completion block won't get called.
-(NSOperation*)fetchImageFromDiskWithPath:(NSString*)path completion:(RUDiskImageFetchingController_QueryCompletedBlock)completion;

-(void)removeImageFromCacheAtFilePath:(NSString*)filePath;

+(instancetype)sharedInstance;

@end
