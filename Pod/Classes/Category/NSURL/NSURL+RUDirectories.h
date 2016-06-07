//
//  NSURL+RUDirectories.h
//  VibeWithIt
//
//  Created by Benjamin Maer on 10/17/14.
//  Copyright (c) 2014 VibeWithIt. All rights reserved.
//

#import <Foundation/Foundation.h>





@interface NSURL (RUDirectories)

+(instancetype)ru_pathForDirectory:(NSSearchPathDirectory)directory;
+(instancetype)ru_pathForDocumentsDirectory;

@end
