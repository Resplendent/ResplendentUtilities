//
//  NSURL+RUDirectories.m
//  VibeWithIt
//
//  Created by Benjamin Maer on 10/17/14.
//  Copyright (c) 2014 VibeWithIt. All rights reserved.
//

#import "NSURL+RUDirectories.h"
#import "RUConditionalReturn.h"
#import "RUClassOrNilUtil.h"





@implementation NSURL (RUDirectories)

+(instancetype)ru_pathForDirectory:(NSSearchPathDirectory)directory
{
	NSArray* paths = [[NSFileManager defaultManager] URLsForDirectory:directory inDomains:NSUserDomainMask];
	kRUConditionalReturn_ReturnValueNil(paths.count != 1, YES);
	
	NSURL* path = kRUClassOrNil(paths.lastObject, NSURL);
	kRUConditionalReturn_ReturnValueNil(path == nil, YES);
	
	return path;
}

+(instancetype)ru_pathForDocumentsDirectory
{
	return [self ru_pathForDirectory:NSDocumentDirectory];
}

@end
