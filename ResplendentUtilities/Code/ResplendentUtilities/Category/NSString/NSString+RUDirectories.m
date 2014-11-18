//
//  NSString+RUDirectories.m
//  VibeWithIt
//
//  Created by Benjamin Maer on 10/17/14.
//  Copyright (c) 2014 VibeWithIt. All rights reserved.
//

#import "NSString+RUDirectories.h"
#import "RUConditionalReturn.h"
#import "RUClassOrNilUtil.h"





@implementation NSString (RUDirectories)

+(instancetype)ru_pathForDirectory:(NSSearchPathDirectory)directory
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(directory, NSUserDomainMask, YES);
	kRUConditionalReturn_ReturnValueNil(paths.count != 1, YES);
	
	NSString* path = kRUStringOrNil(paths.lastObject);
	kRUConditionalReturn_ReturnValueNil(path.length == 0, YES);

	return path;
}

+(instancetype)ru_pathForDocumentsDirectory
{
	return [self ru_pathForDirectory:NSDocumentDirectory];
}

@end
